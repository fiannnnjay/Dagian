
const video = document.getElementById('video');
const result = document.getElementById('result');

Promise.all([
  faceapi.nets.tinyFaceDetector.loadFromUri('./models')
]).then(startVideo);

function startVideo() {
  navigator.mediaDevices.getUserMedia({ video: true })
    .then(stream => {
      video.srcObject = stream;
    })
    .catch(err => console.error("Gagal akses kamera:", err));
}

video.addEventListener('play', () => {
  const canvas = faceapi.createCanvasFromMedia(video);
  document.body.append(canvas);
  const displaySize = { width: video.width, height: video.height };
  faceapi.matchDimensions(canvas, displaySize);

  setInterval(async () => {
    const detections = await faceapi.detectAllFaces(video, new faceapi.TinyFaceDetectorOptions());
    const resized = faceapi.resizeResults(detections, displaySize);
    canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);
    faceapi.draw.drawDetections(canvas, resized);

    if (detections.length > 0) {
      result.style.display = "block";
      result.innerHTML = `
        <h2>Wajah Terdeteksi ✅</h2>
        <p><strong>Simulasi Kondisi:</strong> Jerawat Sedang</p>
        <p><strong>Rekomendasi:</strong> Gunakan face wash dengan <b>Niacinamide (Vitamin B3)</b> + <b>Salicylic Acid</b></p>
      `;
    } else {
      result.style.display = "none";
    }

  }, 1000);
});
