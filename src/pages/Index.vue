<template>
  <q-page class="row justify-center items-center">
    <div style="text-align:center;">
      <img
        style="padding-bottom:15%"
        src="statics/logo.png"
        alt="app logo"
        width="30%"
      >
    </div>
    <div
      class="column q-px-md q-py-md"
      style="margin-top: -280px; width:100%"
    >
      <div class="q-pb-md">
        <q-input
          placeholder="Ingrese el link de la sala a conectarse"
          v-model="roomId"
          label-color="white"
        >
          <template v-slot:append>
            <q-icon
              :name="roomId.length > 0 ? 'close' : 'assignment' "
              @click="copyFromClipBoard"
              class="cursor-pointer"
              color="white"
            />
          </template>
        </q-input>
      </div>
      <div
        class="col-11 q-pt-xl"
        style="text-align:center"
      >
        <q-btn
          color="dark"
          size="md"
          @click="goToRoom"
        >
          Ir a la sala
        </q-btn>
      </div>
    </div>
  </q-page>
</template>

<script>
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady () {
  console.log("window.open works well");
}

export default {
  name: 'PageIndex',
  data () {
    return {
      roomId: ""
    }
  },
  mounted: function () {
    var permissions = cordova.plugins.permissions;
    var list = [
      permissions.CAMERA,
      permissions.MICROPHONE
    ];
    permissions.requestPermissions(list, function () {
      console.log("PERMISSIONS GRANTED")
      //var ref = cordova.InAppBrowser.open('https://meeting.liranka.com:8443/proof', '_blank', 'location=yes');
    }, function (error) {
      console.log(error)
    });

  },
  methods: {
    goToRoom: function () {
      var expression = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/gi;
      var regex = new RegExp(expression);
      if (this.roomId.match(regex)) {
        let splitedUrl = this.roomId.split("/")
        let id = splitedUrl[splitedUrl.length - 1]
        jitsiplugin.loadURL(this.roomId, id, false, function (data) {
          if (data === "CONFERENCE_WILL_LEAVE") {
            jitsiplugin.destroy(function (data) {
              // call finished
            }, function (err) {
              console.log(err);
            });
          }
        }, function (err) {
          console.log(err);
        });
      }
      else {
        this.$q.notify({
          message: 'El enlace proporcionado no es válido, intente de nuevo.',
          color: 'dark',
          textColor: 'white',
          icon: 'warning'
        })
      }
    },
    copyFromClipBoard: function () {
      var vm = this
      if (vm.roomId.length == 0) {
        console.log('READING CLIPBOARD')
        cordova.plugins.clipboard.paste(function (text) {
          console.log("GOT TEXT:" + text)
          vm.roomId = text
        });
      }
      else {
        vm.roomId = ""
      }
    }
  }
}
</script>

<style lang="stylus">
main {
  background-image: radial-gradient(#9A1F1F, #610A0A);
}

input {
  color: whitesmoke !important;
}
</style>