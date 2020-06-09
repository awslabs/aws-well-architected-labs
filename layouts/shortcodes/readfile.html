{{/*

Overrides the Docsy theme's default
[`readfile` shortcode](https://github.com/google/docsy/blob/master/layouts/shortcodes/readfile.md).


Use this `readfile` shortcode to include the contents of a file into another file.
Specify the `readfile` shortcode in a specific location within the "parent"
file to "include" content from the source file.

Default behavior is to obtain source files in a directory that is relative to
the parent file. See details below.

IMPORTANT: You cannot nest shortcodes. When the Hugo build runs on a file,
any shortcodes within that file are processed. For example, if you use `readFile`
to include a source file, and that source file contains another shortcode,
none of those "nested shortcodes" are processed. Nesting a shortcode within another
shortcode results in incorrectly rendered content
(ie. `{{% the short code syntax shows in the HTML of the parent file %}}`).

Syntax:
* For Markdown: Use %, `{{%...%}}`. This sends the source file to the Markdown
  processor and also enables the in-page TOC (in the right-side nav).

  Examples:
  * Include a `README.md` in the same folder's `_index.md` file:
    `{{% readfile file="README.md" %}}`

    Important: For SEO, all README.md files that are not used by the required
    `_index.md` (Hugo section definition) are renamed to index.md at build time.
    If you want to use a `readFile` for some other `README.md` file
    (a `README.md` file is not used by and `_index.md` section def),
    you must specify `index.md` (no underscore).

  * Include any Markdown file, like `shared-content.md`, into another
    parent file that lives in the same folder:
    `{{% readfile file="shared-content.md" %}}`

* For HTML: Use < >, `{{<...>}}`. This prevents Hugo from sending the content to
  the Markdown processor and copies in the content as is.

  * Example of an HTML source file in same folder as the parent file:
    `{{< readfile file="HTML-FILE.html" >}}`

* For code: Use < >, `{{<...>}}` and specify the `code` and `lang` flags to include
  syntax highlighting. See details about the parameter flags below.
  Examples:
  * A Go lang file (...go) in same folder as the parent file:
    `{{< readfile file="code-written-in.go" code="true" lang="go" >}}`
  * A Java file (...java) in a sub-folder (below the parent file):
    `{{< readfile file="main/java/com/code-written-in.java" code="true" lang="java" >}}`

Parameters:
* `file="the-source-file-path-and-or-name.here"`: REQUIRED. By default,
  specifies the filepath that is relative to the parent file in which the `readfile` is called.
  * DEFAULT: Relative filepath:
    `{{% readfile file="example-source-file.md" %}}`

    Example folder
      |--example-source-file.md
      |--example-parent-file-with-readfile-call.md

  * OPTIONAL: Full filepath from site's `baseURL` (denoted by the require `/` forwardslash):
    `{{% readfile file="/docs/one-or-more-sub-directories/example-source-file.md" %}}`

    Include a `/` as the prefix to the filepath reverts to the original behavior
    of the Hugo `readFile` function, see details here:
    https://gohugo.io/functions/readfile/

    Important: Do not specify file paths that rely on the site's `baseURL`
    for any content that is versioned or depends on versioned content
    (note: everything in the /docs/ folder gets versioned).
    Versioned content gets moved to a different branch and folder for each
    release and therefore, a relative file path must be used.

* `code="true"`: Use to include a file and add syntax highlighting to the content
  (the file is not processed, just copied as is).

  * `lang="programming-language"`: The programming language syntax highlighting.
    List of supported values:
    https://gohugo.io/content-management/syntax-highlighting/#list-of-chroma-highlighting-languages

*/}}

{{/* Get the filepath */}}
{{/* If the first character is "/", the path is from the site's `baseURL`. */}}
{{ if eq (.Get "file" | printf "%.1s") "/" }}

{{/* Use Hugo `readfile` behavior of path from site's `baseURL`. */}}
{{ $.Scratch.Set "filepath" ( .Get "file" ) }}

{{ else }}

{{/* Make relative: Fetch the current directory and then append it to the specified `file=""` value */}}
{{ $.Scratch.Set "filepath" $.Page.Dir }}
{{ $.Scratch.Add "filepath" ( .Get "file" ) }}

{{ end }}


{{/* Check if the specified file exists */}}
{{ if fileExists ($.Scratch.Get "filepath") }}

{{/* If Code, then highlight with the specified language. */}}
{{ if eq (.Get "code") "true" }}

{{ highlight ($.Scratch.Get "filepath" | readFile | safeHTML ) (.Get "lang") "" }}

{{ else }}

{{/* If HTML or Markdown. For Markdown`{{%...%}}`,  don't send content to processor again (use safeHTML). */}}
{{ $.Scratch.Get "filepath" | readFile | safeHTML }}

{{ end }}

{{/* Say something if the file is not found and display the path that was specified in the shortcode (`file=" "`). */}}
{{ else }}

<p style="color: #D74848"><b><i>Something's not right. The <code>{{ .Get "file" }}</code> file was not found.</i></b></p>

{{ end }}
