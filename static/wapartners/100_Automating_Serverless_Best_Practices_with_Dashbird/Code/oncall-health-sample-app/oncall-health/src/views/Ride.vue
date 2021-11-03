<template>
<div class="page-ride">


<mapComponent :token="authToken" />

   <div class="info panel panel-default">
        <div class="panel-heading">
            <button id="request" class="btn btn-primary" :disabled="disableInputBool" v-on:click="triggerRequest()" >{{buttonText}}</button>
            <amplify-sign-out></amplify-sign-out>
        </div>
        <div class="panel-body">
            <ol id="updates">
                <li>Click the map to set your location.</li>
                <li>You are authenticated, Click here to see your <a v-on:click="show()">auth token</a></li>
                <li v-for="item in items">
                    {{ item.message }}
                </li>
            </ol>
        </div>
  </div>

    <div id="main">
        <div id="map">
        </div>
    </div>


    <modal name="auth-modal" tabindex="-1"  aria-labelledby="authToken">

                <div class="modal-header">
                    <button v-on:click="hide()" type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Your Auth Token</h4>
                </div>
                <div class="modal-body">
                   
                    <div class="AuthMessage" v-if="authMessage === true">
                        <p>This page is not functional yet because there is no API invoke URL configured in <a href="/src/config.js">/src/config.js</a>. You'll configure this in Module 3.</p>
                        <p>In the meantime, if you'd like to test the Amazon Cognito user pool authorizer for your API, use the auth token below:</p>
                    </div>
                    <textarea class="authToken">{{authToken}}</textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" v-on:click="hide()" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>

    </modal>
</div>

</template>

<script>
import Vue from 'vue'
import footers from '@/components/footer.vue'
import mapView from '@/components/map.vue'
import VModal from 'vue-js-modal'
var config = require('../config.js')

Vue.use(VModal)

export default {
  name: 'unicorns',
  data(){
      return {
          items: [
        ],

          authToken:"",
          showModal:false,
          authMessage:false,
          disableInputBool:true,
          buttonText:"Set Pickup",
      }
  },
  components: {
    footers:footers,
    mapComponent:mapView,
    map:{}
  },
  async mounted(){
        const session = await this.$Amplify.Auth.currentSession()
        const Jwt = session.idToken.jwtToken; 
        if (config.api.invokeUrl===""){
            this.authMessage = true;
            this.show()
        }
        
        
        if(!Jwt){
            alert('No Authorization token!')
        }else{
            this.authToken = Jwt
        }
        
  },
  methods: {
         addItem(text){
             this.items.push({message:text})
         },
        enableButton(ev){
            this.disableInputBool=false
            this.map = ev
            this.buttonText="Request BlueCar"
        },
        disableButton(){
            this.disableInputBool=true
             this.buttonText="Set Pickup"
        },
        show () {
            this.$modal.show('auth-modal');
        },
        hide () {
            this.$modal.hide('auth-modal');
        },
        triggerRequest (){
            this.$children[0].go(this.map)
            this.disableButton();
        }
    }
}
</script>

<style>
@import 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css';
@import 'https://js.arcgis.com/4.3/esri/css/main.css';
@import '/css/ride.css';
@import '/css/message.css';

html, body, #app, .page-ride, #viewDiv{
padding: 0;
margin: 0;
height: 100%;
width: 100%;

}

</style>