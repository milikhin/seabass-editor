/* globals describe, expect, it */
import { v4 as uuid } from 'uuid'
import { postMessage, createEditor, testFilePathRequired } from '../helpers'

describe.only('#appendContent', () => {
  it('should set file content', () => {
    const originalContent = uuid()
    const { filePath, editor } = createEditor({ content: originalContent })
    const newContent = uuid()
    postMessage({
      action: 'setContent',
      data: {
        filePath,
        content: newContent
      }
    })

    expect(editor._ace.getValue()).toEqual(newContent)
  })

  it('should append content to the end of file', () => {
    const originalContent = uuid()
    const { filePath, editor } = createEditor({ content: originalContent })
    const appendedContent = uuid()
    postMessage({
      action: 'setContent',
      data: {
        filePath,
        content: appendedContent,
        append: true
      }
    })

    expect(editor._ace.getValue()).toEqual(`${originalContent}${appendedContent}`)
  })

  it('should throw if `filePath` is missing', () => {
    testFilePathRequired('setContent')
  })
})
