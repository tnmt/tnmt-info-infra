function handler(event) {
  var request = event.request;
  var uri = request.uri;

  // Append index.html for directory requests
  if (uri.endsWith('/')) {
    request.uri += 'index.html';
  } else if (!uri.includes('.')) {
    // No file extension - add trailing slash and index.html
    request.uri += '/index.html';
  }

  return request;
}
