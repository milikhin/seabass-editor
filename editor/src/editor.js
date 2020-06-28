import ace from 'ace-builds/src-noconflict/ace'

import 'ace-builds/webpack-resolver'
import 'ace-builds/src-noconflict/theme-twilight'
import 'ace-builds/src-noconflict/theme-chrome'

import modelist from 'ace-builds/src-noconflict/ext-modelist'
// import beautify from 'ace-builds/src-noconflict/ext-beautify'
import 'ace-builds/src-noconflict/ext-language_tools'

import md5 from 'blueimp-md5'

/**
 * Editor window
 */
export default class Editor {
  constructor ({
    elem = document.getElementById('root'),
    isSailfish = false,
    isTerminal = false
  } = {}) {
    this._editorElem = elem
    this._isTerminal = isTerminal
    this._ace = ace.edit(this._editorElem, {
      wrap: true,
      tabSize: 2,
      useSoftTabs: true,
      navigateWithinSoftTabs: true,
      showFoldWidgets: false,
      indentedSoftWrap: false,
      animatedScroll: false,
      enableBasicAutocompletion: true,
      enableSnippets: true,
      enableLiveAutocompletion: true,

      showGutter: !isTerminal,
      showLineNumbers: !isTerminal,
      scrollPastEnd: 0.5
    })
    this._initialContentHash = undefined
    this._onChangeTimer = undefined
    this._onChangeTimeout = 250
    this._changeListeners = []
    this._lastScrollTop = 0
    this._isSailfish = false

    window.addEventListener('resize', this._onResize)
    if (isSailfish) {
      this._applyPlatformHaks()
    }
  }

  // beautify () {
  //   beautify.beautify(this._ace.session)
  // }

  setContent (content, append = false) {
    if (!append) {
      return this._ace.setValue(content)
    }
    const session = this._ace.getSession()
    session.insert({
      row: session.getLength(),
      column: 0
    }, content.toString())

    this._ace.navigateFileEnd()
    this._ace.renderer.scrollCursorIntoView()
  }

  destroy () {
    this._ace.destroy()
    this._editorElem.parentElement.removeChild(this._editorElem)
    window.removeEventListener('resize', this._onResize)
  }

  /**
   * Returns editor content for the given file
   * @returns {string|undefined} - file content
   */
  getContent () {
    return this._ace.getValue()
  }

  keyDown (keyCode) {
    this._ace.onCommandKey({}, 0, keyCode)
  }

  /**
   * Load given content using given mode
   * @param {string} fileUrl - /path/to/file
   * @param {string} content - editor content
   * @returns {undefined}
   */
  loadFile (filePath, content, readOnly) {
    this._initialContentHash = md5(content)
    const editorSession = this._ace.getSession()
    editorSession.off('change', this._onChange)
    this._ace.getSelection().off('changeSelection', this._onChange)
    this._ace.setOption('readOnly', readOnly)

    // load new content and activate required mode
    this._ace.setValue(content)
    if (!this._isTerminal) {
      const { mode } = modelist.getModeForPath(filePath)
      editorSession.setMode(mode)
    }
    this._ace.clearSelection()
    this._ace.navigateFileStart()
    editorSession.getUndoManager().reset()

    editorSession.on('change', this._onChange)
    this._ace.getSelection().on('changeSelection', this._onChange)
  }

  setSavedContent (content) {
    this._initialContentHash = md5(content)
    this._onChange()
  }

  activate () {
    this._onChange()
  }

  deactivate () {
    if (!this._ace.completer) {
      return
    }
    this._ace.completer.detach()
  }

  navigateDown () {
    // 1. Position cursor
    this._ace.navigateDown()
    // 2. Scroll editor into the current cursor position
    this._ace.renderer.scrollCursorIntoView()
  }

  navigateLeft () {
    this._ace.navigateLeft()
    this._ace.renderer.scrollCursorIntoView()
  }

  navigateRight () {
    this._ace.navigateRight()
    this._ace.renderer.scrollCursorIntoView()
  }

  navigateUp () {
    this._ace.navigateUp()
    this._ace.renderer.scrollCursorIntoView()
  }

  navigateFileEnd () {
    this._ace.navigateFileEnd()
    this._ace.renderer.scrollCursorIntoView()
  }

  navigateFileStart () {
    this._ace.navigateFileStart()
    this._ace.renderer.scrollCursorIntoView()
  }

  navigateLineEnd () {
    this._ace.navigateLineEnd()
    this._ace.renderer.scrollCursorIntoView()
  }

  navigateLineStart () {
    this._ace.navigateLineStart()
    this._ace.renderer.scrollCursorIntoView()
  }

  redo () {
    this._ace.redo()
  }

  undo () {
    this._ace.undo()
  }

  onChange (callback) {
    this._changeListeners = [callback]
  }

  setPreferences ({ isDarkTheme }) {
    if (isDarkTheme !== undefined) {
      this._ace.setTheme(`ace/theme/${isDarkTheme ? 'twilight' : 'chrome'}`)
    }
  }

  toggleReadOnly () {
    const readOnly = this._ace.getOption('readOnly')
    this._ace.setOption('readOnly', !readOnly)
    this._onChange()
  }

  _applyPlatformHaks () {
    // debounce scrollTop workaround too prevent tearing when scroll is animated
    this._isSailfish = true
    this._scrollDebounced = false
    this._ace.getSession().on('changeScrollTop', scrollTop => {
      if (this._scrollDebounced) {
        return
      }

      setTimeout(() => {
        this._scrollDebounced = false
      }, 100)
      this._scrollDebounced = true
      if (this._lastScrollTop > scrollTop) {
        window.scrollTo(0, 1)
      } else {
        window.scrollTo(0, 0)
      }

      this._lastScrollTop = scrollTop
    })
  }

  _onChange = () => {
    clearTimeout(this._onChangeTimer)
    this._onChangeTimer = setTimeout(() => {
      const undoManager = this._ace.getSession().getUndoManager()
      const value = this._ace.getSession().getValue()
      const data = {
        hasChanges: this._initialContentHash !== md5(value),
        hasUndo: undoManager.hasUndo(),
        hasRedo: undoManager.hasRedo(),
        isReadOnly: this._ace.getOption('readOnly'),
        selectedText: this._ace.getSelectedText()
      }

      this._changeListeners.forEach(listener => listener(data))
    }, this._onChangeTimeout)
  }

  _onResize = () => {
    this._ace.focus()
    this._ace.renderer.scrollCursorIntoView()
  }
}
