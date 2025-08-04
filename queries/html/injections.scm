(script_element
  (start_tag
    (tag_name) @start_tag_name)
  (raw_text) @javascript
  (#eq? @start_tag_name "script")
  (#set! injection.language "javascript")
  (#set! injection.combined))

(style_element
  (start_tag
    (tag_name) @start_tag_name)
  (raw_text) @css
  (#eq? @start_tag_name "style")
  (#set! injection.language "css")
  (#set! injection.combined))

