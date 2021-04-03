$(".upload").click(function (e) {
  $("#uploader").click();
});

var uploadedFiles = [];
var cameraStream = null;

$("#uploader").change(function (event) {
  const files = event.target.files;
  if (files && files.length > 0 && FileReader) {
    const file = event.target.files[0];
    var fr = new FileReader();
    fr.onload = function () {
      uploadedFiles = [file];
      $(".fileDisplay img").prop("src", fr.result);
      $(".fileDisplay h3").hide();
      $(".iscar h1").text("");
      $(".predict").removeAttr("disabled");
    };
    fr.readAsDataURL(file);
  }
});

$(".predict").click(function (e) {
  console.log("here");
  var fd = new FormData();
  var dataURI = snapshot.firstChild.getAttribute("src");
  var imageData = dataURItoBlob(dataURI);
  fd.append("files[]", imageData, "myImage");
  $(".predict").text("loading");
  $(".predict").prop("disabled", "true");
  $.ajax({
    method: "POST",
    data: fd,
    processData: false,
    contentType: false,
    cache: false,
    url: "/predict/",
    success: function (data) {
      console.log($(this));
      const res = data[0];
      $(".predict").text("Predict");
      $(".predict").removeAttr("disabled");
      $(".iscar h1").text(
        res.isCar ? `Car Present. (${res.confidence * 100}%)` : `No car Present. (${100 - res.confidence * 100}%)`
      );
    },
  });
});
var camera = document.getElementById("camera");

window.addEventListener(
  "load",
  function () {
    var constraints = { video: true };

    function success(stream) {
      cameraStream = stream;
      camera.srcObject = stream;
      var playPromise = camera.play();
      if (playPromise !== undefined) {
        playPromise
          .then(function () {
            setInterval(function () {
              captureSnapshot();
            }, 1000);
          })
          .catch(function (error) {
            console.error(error);
          });
      }
    }

    function failure(error) {
      alert(JSON.stringify(error));
    }

    if (navigator.getUserMedia) navigator.getUserMedia(constraints, success, failure);
    else alert("Your browser does not support getUserMedia()");
  },
  false
);
function sendToServer() {
  var fd = new FormData();
  var dataURI = snapshot.firstChild.getAttribute("src");
  var imageData = dataURItoBlob(dataURI);
  fd.append("files[]", imageData, "myImage");

  $.ajax({
    method: "POST",
    data: fd,
    processData: false,
    contentType: false,
    cache: false,
    url: "/predict/",
    success: function (data) {
      console.log($(this));
      const res = data[0];

      $(".iscar h1").text(
        res.isCar ? `Car Present. (${res.confidence * 100}%)` : `No car Present. (${100 - res.confidence * 100}%)`
      );
    },
  });
}

var capture = document.getElementById("capture");

function captureSnapshot() {
  if (null != cameraStream) {
    var ctx = capture.getContext("2d");
    var img = new Image();

    ctx.drawImage(camera, 0, 0, capture.width, capture.height);

    img.src = capture.toDataURL("image/png");
    img.width = 240;

    snapshot.innerHTML = "";

    snapshot.appendChild(img);
    sendToServer();
  }
}

function dataURItoBlob(dataURI) {
  var byteString = atob(dataURI.split(",")[1]);
  var mimeString = dataURI.split(",")[0].split(":")[1].split(";")[0];

  var buffer = new ArrayBuffer(byteString.length);
  var data = new DataView(buffer);

  for (var i = 0; i < byteString.length; i++) {
    data.setUint8(i, byteString.charCodeAt(i));
  }

  return new Blob([buffer], { type: mimeString });
}
