((script_element
  (start_tag) @_no_type_lang
  (raw_text) @injection.content)
  (#not-lua-match? @_no_type_lang "%slang%s*=")
  (#not-lua-match? @_no_type_lang "%stype%s*=")
  (#set! injection.language "javascript"))

