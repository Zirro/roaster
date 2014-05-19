roaster = require '../lib/roaster'
Path = require 'path'
Fs = require 'fs'

fixtures_dir = Path.join(__dirname, "fixtures")

describe "roaster", ->

  describe "options", ->
    describe "passing options.isFile = true", ->
      it "returns a rendered file", ->
        callback = jasmine.createSpy()
        roaster Path.join(fixtures_dir, "markdown.md"), {isFile: true}, callback

        waitsFor ->
          callback.callCount > 0

        runs ->
          [err, contents] = callback.mostRecentCall.args
          expect(err).toBeNull()
          expect(contents).toContain '<code class="lang-bash">'
    describe "not passing options.isFile", ->
      it "returns a rendered file", ->
        contents = Fs.readFileSync(Path.join(fixtures_dir, "markdown.md"), {encoding: "utf8"})
        roaster contents, (err, contents) ->
          expect(err).toBeNull()
          expect(contents).toContain '<code class="lang-bash">'

  describe "emoji", ->
    it "returns emoji it knows", ->
      callback = jasmine.createSpy()
      roaster Path.join(fixtures_dir, "emoji.md"), {isFile: true}, callback

      waitsFor ->
        callback.callCount > 0

      runs ->
        [err, contents] = callback.mostRecentCall.args

        expect(err).toBeNull()
        expect(contents).toEqual '<p><img class="emoji" title=":trollface:" alt="trollface" src="/Users/garentorikian/Development/roaster/node_modules/emoji-images/pngs/trollface.png" height="20"></p>\n<p><img class="emoji" title=":shipit:" alt="shipit" src="/Users/garentorikian/Development/roaster/node_modules/emoji-images/pngs/shipit.png" height="20"></p>\n<p><img class="emoji" title=":smiley:" alt="smiley" src="/Users/garentorikian/Development/roaster/node_modules/emoji-images/pngs/smiley.png" height="20"></p>'
    it "can sanitize and return", ->
      callback = jasmine.createSpy()
      roaster Path.join(fixtures_dir, "emoji.md"), {isFile: true, sanitize:true}, callback

      waitsFor ->
        callback.callCount > 0

      runs ->
        [err, contents] = callback.mostRecentCall.args

        expect(err).toBeNull()
        expect(contents).toEqual '<p><img class="emoji" title=":trollface:" alt="trollface" src="/Users/garentorikian/Development/roaster/node_modules/emoji-images/pngs/trollface.png" height="20"></p>\n<p><img class="emoji" title=":shipit:" alt="shipit" src="/Users/garentorikian/Development/roaster/node_modules/emoji-images/pngs/shipit.png" height="20"></p>\n<p><img class="emoji" title=":smiley:" alt="smiley" src="/Users/garentorikian/Development/roaster/node_modules/emoji-images/pngs/smiley.png" height="20"></p>'
    it "does nothing to unknown emoji", ->
      roaster ":lala:", (err, contents) ->
        expect(err).toBeNull()
        expect(contents).toEqual '<p>:lala:</p>\n'
    it "does not mess up coded emoji", ->
      callback = jasmine.createSpy()
      roaster Path.join(fixtures_dir, "emoji_bad.md"), {isFile: true}, callback

      waitsFor ->
        callback.callCount > 0

      runs ->
        [err, contents] = callback.mostRecentCall.args

        expect(err).toBeNull()
        expect(contents).toEqual '<pre><code class="lang-ruby">not :trollface:\n</code></pre>\n<p>wow <code>that is nice :smiley:</code></p>'
  # describe "headers", ->
  #   [toc, result, resultShort] = []

  #   beforeEach ->
  #     toc = Fs.readFileSync(Path.join(fixtures_dir, "toc.md"), {encoding: "utf8"})
  #     result = Fs.readFileSync(Path.join(fixtures_dir, "toc_normal_result.html"), {encoding: "utf8"})
  #     resultShort = Fs.readFileSync(Path.join(fixtures_dir, "toc_short_result.html"), {encoding: "utf8"})

  #   it "adds anchors to all headings", ->
  #     roaster toc, (err, contents) ->
  #       expect(err).toBeNull()
  #       expect(contents.replace(/^\s+|\s+$/g, '')).toContain result.replace(/\s+$/g, '')

  #   it "truncates anchors on headings, due to options", ->
  #     roaster toc, {anchorMin: 3, anchorMax: 4}, (err, contents) ->
  #       expect(err).toBeNull()
  #       expect(contents.replace(/^\s+|\s+$/g, '')).toContain resultShort.replace(/\s+$/g, '')
