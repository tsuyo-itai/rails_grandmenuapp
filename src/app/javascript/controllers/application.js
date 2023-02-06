// #if0 ------------


// import { Application } from "@hotwired/stimulus"

// const application = Application.start()

// // Configure Stimulus development experience
// application.debug = false
// window.Stimulus   = application

// export { application }

// #else ------------

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as Vue from "vue";

const App = Vue.createApp({
    data(){
        return {
            text: 'Hello Vue!! test ok!'
        }
    },
})

App.mount("#app");

// #endif ------------
