assert('Base32.encode') do
  test = [
   {:data => '',       :expect => '' },
   {:data => 'a',      :expect => 'ME======'},
   {:data => 'abcde',  :expect => 'MFRGGZDF' },
   {:data => 'abcdef', :expect => 'MFRGGZDFMY======' },
   {:data => "\x0",    :expect => 'AA======' },
  ]

  test.each do |t|
    assert_equal Base32.encode(t[:data]), t[:expect]
  end
end

assert('Base32.encode without padding') do
  test = [
   {:data => '',       :expect => ''},
   {:data => 'a',      :expect => 'ME'},
   {:data => 'abcde',  :expect => 'MFRGGZDF'},
   {:data => 'abcdef', :expect => 'MFRGGZDFMY'},
   {:data => "\x0",    :expect => 'AA'},
  ]

  test.each do |t|
    assert_equal Base32.encode(t[:data], false), t[:expect]
  end
end

assert('Base32.decode') do
  test = [
   {:data => '',                 :expect => '' },
   {:data => 'ME======',         :expect => 'a' },
   {:data => 'MFRGGZDF',         :expect => 'abcde' },
   {:data => 'MFRGGZDFMY======', :expect => 'abcdef'  },
   {:data => 'AA======',         :expect => "\x0" },
  ]

  test.each do |t|
    assert_equal Base32.decode(t[:data]), t[:expect]
  end
end
