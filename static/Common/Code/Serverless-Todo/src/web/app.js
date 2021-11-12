// Full spec-compliant TodoMVC with localStorage persistence
// and hash-based routing in ~150 lines.

class TodoData {
  async add(content) {
    let result = await axios.post(`${apiAddress}/`, {
      content,
    })

    if (result.status != 200) {
      return new Error('Not a good response')
    }

    let { todo_id } = result.data

    return todo_id
  }

  async edit(id, content, completed) {
    let result = axios.post(`${apiAddress}/${id}`, {
      content,
      completed
    })

    if (result.status != 200) {
      return new Error('Not a good response')
    }
  }

  async delete(id) {
    let result = await axios.delete(`${apiAddress}/${id}`)

    if (result.status != 200) {
      return new Error('Not a good response')
    }
  }

  async read() {
    let result = await axios.get(`${apiAddress}/`)

    if (result.status != 200) {
      return new Error('Not a good response')
    }

    let { data } = result.data

    return data.map(t => { return {id: t.todo_id, title: t.content, completed: t.completed} })
  }
}

// visibility filters
var filters = {
  all: function (todos) {
    return todos
  },
  active: function (todos) {
    return todos.filter(function (todo) {
      return !todo.completed
    })
  },
  completed: function (todos) {
    return todos.filter(function (todo) {
      return todo.completed
    })
  }
}

// app Vue instance
var app = new Vue({
  // app initial state
  data: {
    todos: [],
    newTodo: '',
    editedTodo: null,
    visibility: 'all'
  },

  async created() {
    this.model = new TodoData()
    this.todos = await this.model.read()
  },

  // watch todos change for localStorage persistence
  watch: {
    todos: {
      handler: function (todos) {
        todos.forEach(t => {
          this.model.edit(t.id, t.title, t.completed)
        })
      },
      deep: true
    }
  },

  // computed properties
  // https://vuejs.org/guide/computed.html
  computed: {
    filteredTodos: function () {
      return filters[this.visibility](this.todos)
    },
    remaining: function () {
      return filters.active(this.todos).length
    },
    allDone: {
      get: function () {
        return this.remaining === 0
      },
      set: function (value) {
        this.todos.forEach(function (todo) {
          todo.completed = value
        })
      }
    }
  },

  filters: {
    pluralize: function (n) {
      return n === 1 ? 'item' : 'items'
    }
  },

  // methods that implement data logic.
  // note there's no DOM manipulation here at all.
  methods: {
    addTodo: async function () {
      var value = this.newTodo && this.newTodo.trim()
      if (!value) {
        return
      }

      let id = await this.model.add(value)

      this.todos.push({
        id: id,
        title: value,
        completed: false
      })
      this.newTodo = ''
    },

    removeTodo: function (todo) {
      this.model.delete(todo.id)
      this.todos.splice(this.todos.indexOf(todo), 1)
    },

    editTodo: function (todo) {
      this.beforeEditCache = todo.title
      this.editedTodo = todo
    },

    doneEdit: function (todo) {
      if (!this.editedTodo) {
        return
      }
      this.editedTodo = null
      todo.title = todo.title.trim()
      if (!todo.title) {
        this.removeTodo(todo)
      }

      this.model.edit(todo.id, todo.title, todo.completed)
    },

    cancelEdit: function (todo) {
      this.editedTodo = null
      todo.title = this.beforeEditCache
    },

    removeCompleted: function () {
      this.todos = filters.active(this.todos)
    }
  },

  // a custom directive to wait for the DOM to be updated
  // before focusing on the input field.
  // https://vuejs.org/guide/custom-directive.html
  directives: {
    'todo-focus': function (el, binding) {
      if (binding.value) {
        el.focus()
      }
    }
  }
})

// handle routing
function onHashChange () {
  var visibility = window.location.hash.replace(/#\/?/, '')
  if (filters[visibility]) {
    app.visibility = visibility
  } else {
    window.location.hash = ''
    app.visibility = 'all'
  }
}

window.addEventListener('hashchange', onHashChange)
onHashChange()

// mount
app.$mount('.todoapp')