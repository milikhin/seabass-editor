import QtQuick 2.9
import QtQuick.Layouts 1.3
import Morph.Web 0.1
import QtWebEngine 1.1

WebView {
  zoomFactor: units.gu(1) / 8
  url: "../../html/index.html"

  onNavigationRequested: function(request) {
    const urlStr = request.url.toString()
    const isHttpRequest = urlStr.indexOf('http') === 0
    if (!isHttpRequest) {
      return
    }

    Qt.openUrlExternally(request.url)
  }
}