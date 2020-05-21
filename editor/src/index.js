import 'babel-polyfill'
import registerApi from './api'
import editorFactory from './editor-factory'

registerApi({
  editorFactory,
  notifyOnLoaded: true,
  apiBackend: window.seabassOptions.apiBackend,

  rootElem: document.getElementById('root'),
  welcomeElem: document.getElementById('welcome')
})
