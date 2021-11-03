<template>
  <div id="app">
    
    <router-view/>
    
  </div>
</template>

<script>
import { components } from "aws-amplify-vue"; // eslint-disable-line


export default {
  name: 'app', 
  components: {
    components
  }
}
</script>