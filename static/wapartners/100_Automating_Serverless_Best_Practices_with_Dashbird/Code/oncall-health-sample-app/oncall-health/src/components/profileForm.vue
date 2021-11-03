/*
 * Copyright 2017-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with
 * the License. A copy of the License is located at
 *
 *     http://aws.amazon.com/apache2.0/
 *
 * or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions
 * and limitations under the License.
 */

<template>
  <div class="form">
    <div class="inputRow" v-for="field in fields" v-bind:key="field.name">
      <div v-if="field.type === 'string'">
        <label class="inputLabel">{{field.label || field.name}}</label>
        <input
          class="input"
          v-model="user[field.name]"
        />
      </div>
      <div class="lineBreak" v-if="field.type === 'lineBreak'"></div>
    </div>
    <div class="actionRow">
      <button class="action" v-on:click="save">Save</button>
    </div>

  <amplify-sign-out></amplify-sign-out>

  </div>


</template>

<script>
import AmplifyStore from '../store/store'

export default {
  name: 'ProfileForm',
  props: ['fields'],
  data () {
    return {
      user: {}
    }
  },
  async mounted () {
    if (AmplifyStore.state.user) {
      const currentUser = await this.$Amplify.Auth.currentUserInfo()
      
      this.user = {
        username: currentUser.username,

        //currentUser.attributes
      }
    }
  },
  methods: {
    save() {
      const cognitoUser = AmplifyStore.state.user;
      if (!this.user || !cognitoUser) { return }
      this.$Amplify.Auth.updateUserAttributes(cognitoUser, this.user).then((res) => {
        console.log(res)
      })
      .catch(e => console.log(e));
    }
  }
}
</script>