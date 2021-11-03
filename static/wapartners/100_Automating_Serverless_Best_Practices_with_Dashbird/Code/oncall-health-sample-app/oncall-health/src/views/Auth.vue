<template>
    <div class="page-auth">

    <menus class="site-header" title="title" />


      <div id="noCognitoMessage" class="configMessage" style="display: none;">
        <div class="backdrop"></div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">No Cognito User Pool Configured</h3>
            </div>
            <div class="panel-body">
                <p>There is no user pool configured in <a href="/js/config.js">/js/config.js</a>. You'll configure this in Module 2 of the workshop.</p>
            </div>
        </div>
      </div>
      <header>
        <img src="/images/logo.png">
      </header>
      <div style="text-align:center;"> 
        <amplify-authenticator></amplify-authenticator>
      </div>
      <div class="container" style="text-align:center;">
          <h3 v-if="user">{{user.username}} is Logged in</h3>
          <a  v-if="user" class="home-button" href="/ride">START HERE!</a>
          
      </div>
    </div>

</template>


<script>
import profileForm from '@/components/profileForm.vue'
import footers from '@/components/footer.vue'
import menu from '@/components/menu.vue'

import { Auth, Storage, Logger } from 'aws-amplify'
import AmplifyStore from '../store/store';
export default {
  name: 'Auth',
  components:{
    profileForm: profileForm,
    footers: footers,
    menus: menu
  },
  data:  () => {
    const that = this;
    return {
      profilePic: false,
      imagePath: `${AmplifyStore.state.user.username}/avatar`,
      photoPickerConfig: {
        header: 'Upload Profile Pic',
        accept: 'image/*',
        path: `${AmplifyStore.state.user.username}/`,
        defaultName: 'avatar'
      },
      mfa: false,
      fields: [
        { type: 'string', name: 'email', label: 'Email' },
        { type: 'string', name: 'phone_number', label: 'Phone Number' }
      ],
    };
  },
  mounted(){
      //console.log('sdf')
      // console.log(Auth._config)
      
  },
  methods: {
    toggleAccordion: function(el) {
      this[el] = !this[el]
    },
  },
  computed: {
    mfaConfig: function() {
      let that = this;
      return {
        mfaDescription: 'My app\'s mfa description!!',
        mfaTypes: ['TOTP', 'SMS', 'None'],
        cancelHandler: function() {
          that.toggleAccordion('mfa')
        },
      }
    },
    user: function() { 
      return AmplifyStore.state.user 
    },
    profilePicAccordion: function() {
      return {
        'is-closed': !this.profilePic,
        'is-primary': this.profilePic,
        'is-dark': !this.profilePic
      };
    },
    mfaAccordion: function() {
      return {
        'is-closed': !this.mfa,
        'is-primary': this.mfa,
        'is-dark': !this.mfa
      };
    }
  }
}

</script>

<style scoped>
.page-auth{
  width: 100vw;
  height: 100vh;
  background-image: url(~/images/background.png);
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center bottom;
  font-family: "fairplex-wide";
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

/* Logo */
header{
  width: 100vw;
  padding: 30px 0 100px;
}
header img{
  margin: 0 auto;
  display: block;
}
</style>