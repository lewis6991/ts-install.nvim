---@type nvim-ts.parsers
return {
  ada = {
    install_info = {
      revision = 'e8e2515465cc2d7c444498e68bdb9f1d86767f95',
      url = 'https://github.com/briot/tree-sitter-ada',
    },
  },
  agda = {
    install_info = {
      revision = 'd3dc807692e6bca671d4491b3bf5c67eeca8c016',
      url = 'https://github.com/tree-sitter/tree-sitter-agda',
    },
  },
  angular = {
    install_info = {
      generate_from_json = true,
      revision = '31182d43b062a350d4bd2449f2fc0d5654972be9',
      url = 'https://github.com/dlvandenberg/tree-sitter-angular',
    },
    requires = { 'html', 'html_tags' },
  },
  apex = {
    install_info = {
      location = 'apex',
      revision = 'caffc6ebd1ab16ba4d4dec367cebb03ca2411872',
      url = 'https://github.com/aheber/tree-sitter-sfapex',
    },
  },
  arduino = {
    install_info = {
      generate_from_json = true,
      revision = 'afb34b2c65f507932c5c6ddbf0d5a9ca6a772f2f',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-arduino',
    },
    requires = { 'cpp' },
  },
  asm = {
    install_info = {
      revision = 'b0306e9bb2ebe01c6562f1aef265cc42ccc53070',
      url = 'https://github.com/RubixDev/tree-sitter-asm',
    },
  },
  astro = {
    install_info = {
      generate_from_json = true,
      revision = '4be180759ec13651f72bacee65fa477c64222a1a',
      url = 'https://github.com/virchau13/tree-sitter-astro',
    },
    requires = { 'html', 'html_tags' },
  },
  authzed = {
    install_info = {
      revision = '1dec7e1af96c56924e3322cd85fdce15d0a31d00',
      url = 'https://github.com/mleonidas/tree-sitter-authzed',
    },
  },
  awk = {
    install_info = {
      revision = 'ba7472152d79a8c916550c80fdbfd5724d07a0c9',
      url = 'https://github.com/Beaglefoot/tree-sitter-awk',
    },
  },
  bash = {
    install_info = {
      revision = '2fbd860f802802ca76a6661ce025b3a3bca2d3ed',
      url = 'https://github.com/tree-sitter/tree-sitter-bash',
    },
  },
  bass = {
    install_info = {
      revision = '28dc7059722be090d04cd751aed915b2fee2f89a',
      url = 'https://github.com/vito/tree-sitter-bass',
    },
  },
  beancount = {
    install_info = {
      revision = '01c0da29e0fc7130420a09d939ecc524e09b6ba6',
      url = 'https://github.com/polarmutex/tree-sitter-beancount',
    },
  },
  bibtex = {
    install_info = {
      revision = 'ccfd77db0ed799b6c22c214fe9d2937f47bc8b34',
      url = 'https://github.com/latex-lsp/tree-sitter-bibtex',
    },
  },
  bicep = {
    install_info = {
      revision = '0092c7d1bd6bb22ce0a6f78497d50ea2b87f19c0',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-bicep',
    },
  },
  bitbake = {
    install_info = {
      revision = 'a5d04fdb5a69a02b8fa8eb5525a60dfb5309b73b',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-bitbake',
    },
  },
  blueprint = {
    install_info = {
      revision = '60ba73739c6083c693d86a1a7cf039c07eb4ed59',
      url = 'https://gitlab.com/gabmus/tree-sitter-blueprint',
    },
  },
  bp = {
    install_info = {
      revision = '4e60cf3c2e613625c06f6f85540b3631e2d06cd3',
      url = 'https://github.com/ambroisie/tree-sitter-bp',
    },
  },
  c = {
    install_info = {
      revision = 'be23d2c9d8e5b550e713ef0f86126a248462ca6e',
      url = 'https://github.com/tree-sitter/tree-sitter-c',
    },
  },
  c_sharp = {
    install_info = {
      revision = '31a64b28292aac6adf44071e449fa03fb80eaf4e',
      url = 'https://github.com/tree-sitter/tree-sitter-c-sharp',
    },
  },
  cairo = {
    install_info = {
      revision = '6238f609bea233040fe927858156dee5515a0745',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-cairo',
    },
  },
  capnp = {
    install_info = {
      revision = '7b0883c03e5edd34ef7bcf703194204299d7099f',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-capnp',
    },
  },
  chatito = {
    install_info = {
      revision = 'a461f20dedb43905febb12c1635bc7d2e43e96f0',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-chatito',
    },
  },
  clojure = {
    install_info = {
      revision = 'f4236d4da8aa92bc105d9c118746474c608e6af7',
      url = 'https://github.com/sogaiu/tree-sitter-clojure',
    },
  },
  cmake = {
    install_info = {
      revision = '69d7a8b0f7493b0dbb07d54e8fea96c5421e8a71',
      url = 'https://github.com/uyha/tree-sitter-cmake',
    },
  },
  comment = {
    install_info = {
      revision = '5d8b29f6ef3bf64d59430dcfe76b31cc44b5abfd',
      url = 'https://github.com/stsewd/tree-sitter-comment',
    },
  },
  commonlisp = {
    install_info = {
      generate_from_json = true,
      revision = 'bf2a65b1c119898a1a17389e07f2a399c05cdc0c',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-commonlisp',
    },
  },
  cooklang = {
    install_info = {
      revision = '4ebe237c1cf64cf3826fc249e9ec0988fe07e58e',
      url = 'https://github.com/addcninblue/tree-sitter-cooklang',
    },
  },
  corn = {
    install_info = {
      revision = '464654742cbfd3a3de560aba120998f1d5dfa844',
      url = 'https://github.com/jakestanger/tree-sitter-corn',
    },
  },
  cpon = {
    install_info = {
      revision = '594289eadfec719198e560f9d7fd243c4db678d5',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-cpon',
    },
  },
  cpp = {
    install_info = {
      generate_from_json = true,
      revision = '0b4aa47f07d958a49260aadc87e8474b03897c23',
      url = 'https://github.com/tree-sitter/tree-sitter-cpp',
    },
    requires = { 'c' },
  },
  css = {
    install_info = {
      revision = 'f6be52c3d1cdb1c5e4dd7d8bce0a57497f55d6af',
      url = 'https://github.com/tree-sitter/tree-sitter-css',
    },
  },
  csv = {
    install_info = {
      location = 'csv',
      revision = '7eb7297823605392d2bbcc4c09b1cd18d6fa9529',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-csv',
    },
    requires = { 'tsv' },
  },
  cuda = {
    install_info = {
      generate_from_json = true,
      revision = '7c97acb8398734d790c86210c53c320df61ff66b',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-cuda',
    },
    requires = { 'cpp' },
  },
  cue = {
    install_info = {
      revision = '8a5f273bfa281c66354da562f2307c2d394b6c81',
      url = 'https://github.com/eonpatapon/tree-sitter-cue',
    },
  },
  d = {
    install_info = {
      revision = 'ac584585a15c4cacd6cda8e6bfe7cb1ca7b3898e',
      url = 'https://github.com/gdamore/tree-sitter-d',
    },
  },
  dart = {
    install_info = {
      revision = 'ac0bb849ccd1a923963af47573b5e396736ff582',
      url = 'https://github.com/UserNobody14/tree-sitter-dart',
    },
  },
  devicetree = {
    install_info = {
      revision = 'fb07e6044ffd36932c57a5be01ba5d6b8a9337bb',
      url = 'https://github.com/joelspadin/tree-sitter-devicetree',
    },
  },
  dhall = {
    install_info = {
      revision = 'affb6ee38d629c9296749767ab832d69bb0d9ea8',
      url = 'https://github.com/jbellerb/tree-sitter-dhall',
    },
  },
  diff = {
    install_info = {
      revision = '19dd5aa52fe339a1d974768a09ee2537303e8ca5',
      url = 'https://github.com/the-mikedavis/tree-sitter-diff',
    },
  },
  disassembly = {
    install_info = {
      revision = '0229c0211dba909c5d45129ac784a3f4d49c243a',
      url = 'https://github.com/ColinKennedy/tree-sitter-disassembly',
    },
  },
  djot = {
    install_info = {
      revision = '886601b67d1f4690173a4925c214343c30704d32',
      url = 'https://github.com/treeman/tree-sitter-djot',
    },
  },
  dockerfile = {
    install_info = {
      revision = '087daa20438a6cc01fa5e6fe6906d77c869d19fe',
      url = 'https://github.com/camdencheek/tree-sitter-dockerfile',
    },
  },
  dot = {
    install_info = {
      revision = '9ab85550c896d8b294d9b9ca1e30698736f08cea',
      url = 'https://github.com/rydesun/tree-sitter-dot',
    },
  },
  doxygen = {
    install_info = {
      revision = 'ccd998f378c3f9345ea4eeb223f56d7b84d16687',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-doxygen',
    },
  },
  dtd = {
    install_info = {
      location = 'dtd',
      revision = '809266ed1694d64dedc168a18893cc254e3edf7e',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-xml',
    },
  },
  earthfile = {
    install_info = {
      revision = 'b0a9bc5737340a9b80b489fe9ae93d7b2fe78cd7',
      url = 'https://github.com/glehmann/tree-sitter-earthfile',
    },
  },
  ebnf = {
    install_info = {
      location = 'crates/tree-sitter-ebnf',
      revision = '8e635b0b723c620774dfb8abf382a7f531894b40',
      url = 'https://github.com/RubixDev/ebnf',
    },
  },
  editorconfig = {
    install_info = {
      revision = 'fd0d64d2fc91eab903bed4c11ce280b62e46f16e',
      url = 'https://github.com/ValdezFOmar/tree-sitter-editorconfig',
    },
  },
  eds = {
    install_info = {
      revision = '0ad62cb635c2f4353359a88dec9e3a57bbf9f66d',
      url = 'https://github.com/uyha/tree-sitter-eds',
    },
  },
  eex = {
    install_info = {
      revision = 'f742f2fe327463335e8671a87c0b9b396905d1d1',
      url = 'https://github.com/connorlay/tree-sitter-eex',
    },
  },
  elixir = {
    install_info = {
      revision = 'c7ae8b77e2749826dcf23df6514f08fdd68c66a3',
      url = 'https://github.com/elixir-lang/tree-sitter-elixir',
    },
  },
  elm = {
    install_info = {
      revision = '09dbf221d7491dc8d8839616b27c21b9c025c457',
      url = 'https://github.com/elm-tooling/tree-sitter-elm',
    },
  },
  elsa = {
    install_info = {
      revision = '0a66b2b3f3c1915e67ad2ef9f7dbd2a84820d9d7',
      url = 'https://github.com/glapa-grossklag/tree-sitter-elsa',
    },
  },
  elvish = {
    install_info = {
      revision = '5e7210d945425b77f82cbaebc5af4dd3e1ad40f5',
      url = 'https://github.com/elves/tree-sitter-elvish',
    },
  },
  embedded_template = {
    install_info = {
      revision = '38d5004a797298dc42c85e7706c5ceac46a3f29f',
      url = 'https://github.com/tree-sitter/tree-sitter-embedded-template',
    },
  },
  erlang = {
    install_info = {
      revision = '8f41b588fe38b981156651ef56b192ed3d158efd',
      url = 'https://github.com/WhatsApp/tree-sitter-erlang',
    },
  },
  facility = {
    install_info = {
      revision = '2d037f2f2bf668737f72e6be6eda4b7918b68d86',
      url = 'https://github.com/FacilityApi/tree-sitter-facility',
    },
  },
  faust = {
    install_info = {
      revision = 'f3b9274514b5f9bf6b0dd4a01c30f9cc15c58bc4',
      url = 'https://github.com/khiner/tree-sitter-faust',
    },
  },
  fennel = {
    install_info = {
      generate_from_json = true,
      revision = 'cfbfa478dc2dbef267ee94ae4323d9c886f45e94',
      url = 'https://github.com/alexmozaidze/tree-sitter-fennel',
    },
  },
  fidl = {
    install_info = {
      revision = '0a8910f293268e27ff554357c229ba172b0eaed2',
      url = 'https://github.com/google/tree-sitter-fidl',
    },
  },
  firrtl = {
    install_info = {
      revision = '8503d3a0fe0f9e427863cb0055699ff2d29ae5f5',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-firrtl',
    },
  },
  fish = {
    install_info = {
      revision = 'a78aef9abc395c600c38a037ac779afc7e3cc9e0',
      url = 'https://github.com/ram02z/tree-sitter-fish',
    },
  },
  foam = {
    install_info = {
      revision = '04664b40c0dadb7ef37028acf3422c63271d377b',
      url = 'https://github.com/FoamScience/tree-sitter-foam',
    },
  },
  forth = {
    install_info = {
      revision = '90189238385cf636b9ee99ce548b9e5b5e569d48',
      url = 'https://github.com/AlexanderBrevig/tree-sitter-forth',
    },
  },
  fortran = {
    install_info = {
      revision = '6b633433fb3f132f21250cf8e8be76d5a6389b7e',
      url = 'https://github.com/stadelmanma/tree-sitter-fortran',
    },
  },
  fsh = {
    install_info = {
      revision = 'fad2e175099a45efbc98f000cc196d3674cc45e0',
      url = 'https://github.com/mgramigna/tree-sitter-fsh',
    },
  },
  func = {
    install_info = {
      revision = 'f780ca55e65e7d7360d0229331763e16c452fc98',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-func',
    },
  },
  fusion = {
    install_info = {
      revision = '19db2f47ba4c3a0f6238d4ae0e2abfca16e61dd6',
      url = 'https://gitlab.com/jirgn/tree-sitter-fusion',
    },
  },
  gdscript = {
    install_info = {
      revision = '1f1e782fe2600f50ae57b53876505b8282388d77',
      url = 'https://github.com/PrestonKnopp/tree-sitter-gdscript',
    },
  },
  gdshader = {
    install_info = {
      revision = 'ffd9f958df13cae04593781d7d2562295a872455',
      url = 'https://github.com/GodOfAvacyn/tree-sitter-gdshader',
    },
  },
  git_config = {
    install_info = {
      revision = '9c2a1b7894e6d9eedfe99805b829b4ecd871375e',
      url = 'https://github.com/the-mikedavis/tree-sitter-git-config',
    },
  },
  git_rebase = {
    install_info = {
      revision = 'bff4b66b44b020d918d67e2828eada1974a966aa',
      url = 'https://github.com/the-mikedavis/tree-sitter-git-rebase',
    },
  },
  gitattributes = {
    install_info = {
      revision = '41940e199ba5763abea1d21b4f717014b45f01ea',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-gitattributes',
    },
  },
  gitcommit = {
    install_info = {
      revision = 'aa5c279287f0895a7ebc76a06e55ac3e4b2df7c7',
      url = 'https://github.com/gbprod/tree-sitter-gitcommit',
    },
  },
  gitignore = {
    install_info = {
      revision = 'f4685bf11ac466dd278449bcfe5fd014e94aa504',
      url = 'https://github.com/shunsambongi/tree-sitter-gitignore',
    },
  },
  gleam = {
    install_info = {
      revision = '426e67087fd62be5f4533581b5916b2cf010fb5b',
      url = 'https://github.com/gleam-lang/tree-sitter-gleam',
    },
  },
  glimmer = {
    install_info = {
      revision = '6b25d265c990139353e1f7f97baf84987ebb7bf0',
      url = 'https://github.com/alexlafroscia/tree-sitter-glimmer',
    },
  },
  glsl = {
    install_info = {
      generate_from_json = true,
      revision = 'ddc3137a2d775aca93084ff997fa13cc1691058a',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-glsl',
    },
    requires = { 'c' },
  },
  gn = {
    install_info = {
      revision = 'bc06955bc1e3c9ff8e9b2b2a55b38b94da923c05',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-gn',
    },
    readme_name = 'GN (Generate Ninja)',
  },
  gnuplot = {
    install_info = {
      revision = '3c895f5d9c0b3a3c7e02383766b462c21913c000',
      url = 'https://github.com/dpezto/tree-sitter-gnuplot',
    },
  },
  go = {
    install_info = {
      revision = '7ee8d928db5202f6831a78f8112fd693bf69f98b',
      url = 'https://github.com/tree-sitter/tree-sitter-go',
    },
  },
  goctl = {
    install_info = {
      revision = 'f107937259c7ec4bb05f7e3d2c24b89ac36d4cc3',
      url = 'https://github.com/chaozwn/tree-sitter-goctl',
    },
  },
  godot_resource = {
    install_info = {
      revision = '2ffb90de47417018651fc3b970e5f6b67214dc9d',
      url = 'https://github.com/PrestonKnopp/tree-sitter-godot-resource',
    },
  },
  gomod = {
    install_info = {
      revision = '1f55029bacd0a6a11f6eb894c4312d429dcf735c',
      url = 'https://github.com/camdencheek/tree-sitter-go-mod',
    },
  },
  gosum = {
    install_info = {
      revision = 'e2ac513b2240c7ff1069ae33b2df29ce90777c11',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-go-sum',
    },
  },
  gotmpl = {
    install_info = {
      revision = '9d3f6e526dd074b9edae9070b7bb778f00e87a5b',
      url = 'https://github.com/ngalaiko/tree-sitter-go-template',
    },
  },
  gowork = {
    install_info = {
      revision = '949a8a470559543857a62102c84700d291fc984c',
      url = 'https://github.com/omertuc/tree-sitter-go-work',
    },
  },
  gpg = {
    install_info = {
      revision = 'f99323fb8f3f10b6c69db0c2f6d0a14bd7330675',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-gpg-config',
    },
  },
  graphql = {
    install_info = {
      revision = '5e66e961eee421786bdda8495ed1db045e06b5fe',
      url = 'https://github.com/bkegley/tree-sitter-graphql',
    },
  },
  groovy = {
    install_info = {
      revision = '105ee343682b7eee86b38ec6858a269e16474a72',
      url = 'https://github.com/murtaza64/tree-sitter-groovy',
    },
  },
  gstlaunch = {
    install_info = {
      revision = '549aef253fd38a53995cda1bf55c501174372bf7',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-gstlaunch',
    },
  },
  hack = {
    install_info = {
      revision = 'fca1e294f6dce8ec5659233a6a21f5bd0ed5b4f2',
      url = 'https://github.com/slackhq/tree-sitter-hack',
    },
  },
  hare = {
    install_info = {
      revision = '4af5d82cf9ec39f67cb1db5b7a9269d337406592',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-hare',
    },
  },
  haskell = {
    install_info = {
      revision = 'a50070d5bb5bd5c1281740a6102ecf1f4b0c4f19',
      url = 'https://github.com/tree-sitter/tree-sitter-haskell',
    },
  },
  haskell_persistent = {
    install_info = {
      revision = '577259b4068b2c281c9ebf94c109bd50a74d5857',
      url = 'https://github.com/MercuryTechnologies/tree-sitter-haskell-persistent',
    },
  },
  hcl = {
    install_info = {
      revision = '9e3ec9848f28d26845ba300fd73c740459b83e9b',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-hcl',
    },
  },
  heex = {
    install_info = {
      revision = '6dd0303acf7138dd2b9b432a229e16539581c701',
      url = 'https://github.com/connorlay/tree-sitter-heex',
    },
  },
  helm = {
    install_info = {
      location = 'dialects/helm',
      revision = '9d3f6e526dd074b9edae9070b7bb778f00e87a5b',
      url = 'https://github.com/ngalaiko/tree-sitter-go-template',
    },
  },
  hjson = {
    install_info = {
      generate_from_json = true,
      revision = '02fa3b79b3ff9a296066da6277adfc3f26cbc9e0',
      url = 'https://github.com/winston0410/tree-sitter-hjson',
    },
    requires = { 'json' },
  },
  hlsl = {
    install_info = {
      generate_from_json = true,
      revision = '5d788a46727c8199a7c63a3c849092e0364375b6',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-hlsl',
    },
    requires = { 'cpp' },
  },
  hlsplaylist = {
    install_info = {
      revision = '3bfda9271e3adb08d35f47a2102fe957009e1c55',
      url = 'https://github.com/Freed-Wu/tree-sitter-hlsplaylist',
    },
  },
  hocon = {
    install_info = {
      generate_from_json = true,
      revision = 'c390f10519ae69fdb03b3e5764f5592fb6924bcc',
      url = 'https://github.com/antosha417/tree-sitter-hocon',
    },
  },
  hoon = {
    install_info = {
      revision = 'a24c5a39d1d7e993a8bee913c8e8b6a652ca5ae8',
      url = 'https://github.com/urbit-pilled/tree-sitter-hoon',
    },
  },
  html = {
    install_info = {
      revision = 'e4d834eb4918df01dcad5c27d1b15d56e3bd94cd',
      url = 'https://github.com/tree-sitter/tree-sitter-html',
    },
    requires = { 'html_tags' },
  },
  html_tags = {
  },
  htmldjango = {
    install_info = {
      revision = 'ea71012d3fe14dd0b69f36be4f96bdfe9155ebae',
      url = 'https://github.com/interdependence/tree-sitter-htmldjango',
    },
  },
  http = {
    install_info = {
      revision = '5ae6c7cfa62a7d7325c26171a1de4f6b866702b5',
      url = 'https://github.com/rest-nvim/tree-sitter-http',
    },
  },
  hurl = {
    install_info = {
      revision = 'fba6ed8db3a009b9e7d656511931b181a3ee5b08',
      url = 'https://github.com/pfeiferj/tree-sitter-hurl',
    },
  },
  hyprlang = {
    install_info = {
      revision = '6858695eba0e63b9e0fceef081d291eb352abce8',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-hyprlang',
    },
  },
  idl = {
    install_info = {
      revision = '4ebc74fa805baec21fca01ff500f986dc0f595c5',
      url = 'https://github.com/cathaysia/tree-sitter-idl',
    },
  },
  ini = {
    install_info = {
      revision = '87176e524f0a98f5be75fa44f4f0ff5c6eac069c',
      url = 'https://github.com/justinmk/tree-sitter-ini',
    },
  },
  inko = {
    install_info = {
      revision = '234c87be1dac20f766ddf6f486a7bde2a4bc5594',
      url = 'https://github.com/inko-lang/tree-sitter-inko',
    },
  },
  ispc = {
    install_info = {
      generate_from_json = true,
      revision = '9b2f9aec2106b94b4e099fe75e73ebd8ae707c04',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-ispc',
    },
    requires = { 'c' },
  },
  janet_simple = {
    install_info = {
      revision = 'ea842cb57a90865c8f50bcb4499de1a94860f3a4',
      url = 'https://github.com/sogaiu/tree-sitter-janet-simple',
    },
  },
  java = {
    install_info = {
      revision = '953abfc8bb3eb2f578e1f461edba4a9885f974b8',
      url = 'https://github.com/tree-sitter/tree-sitter-java',
    },
  },
  javascript = {
    install_info = {
      revision = '12e45374422f6051648717be62f0ffc40a279ee2',
      url = 'https://github.com/tree-sitter/tree-sitter-javascript',
    },
    requires = { 'ecma', 'jsx' },
  },
  jq = {
    install_info = {
      revision = '13990f530e8e6709b7978503da9bc8701d366791',
      url = 'https://github.com/flurie/tree-sitter-jq',
    },
  },
  jsdoc = {
    install_info = {
      revision = '49fde205b59a1d9792efc21ee0b6d50bbd35ff14',
      url = 'https://github.com/tree-sitter/tree-sitter-jsdoc',
    },
  },
  json = {
    install_info = {
      revision = '94f5c527b2965465956c2000ed6134dd24daf2a7',
      url = 'https://github.com/tree-sitter/tree-sitter-json',
    },
  },
  json5 = {
    install_info = {
      revision = 'ab0ba8229d639ec4f3fa5f674c9133477f4b77bd',
      url = 'https://github.com/Joakker/tree-sitter-json5',
    },
  },
  jsonc = {
    install_info = {
      generate_from_json = true,
      revision = '02b01653c8a1c198ae7287d566efa86a135b30d5',
      url = 'https://gitlab.com/WhyNotHugo/tree-sitter-jsonc',
    },
    requires = { 'json' },
  },
  jsonnet = {
    install_info = {
      revision = 'd34615fa12cc1d1cfc1f1f1a80acc9db80ee4596',
      url = 'https://github.com/sourcegraph/tree-sitter-jsonnet',
    },
  },
  jsx = {
  },
  julia = {
    install_info = {
      revision = 'f1baa5f8e271109d01cc8ff7473c11df2d8a9aee',
      url = 'https://github.com/tree-sitter/tree-sitter-julia',
    },
  },
  just = {
    install_info = {
      revision = '6648ac1c0cdadaec8ee8bcf9a4ca6ace5102cf21',
      url = 'https://github.com/IndianBoy42/tree-sitter-just',
    },
  },
  kconfig = {
    install_info = {
      revision = '486fea71f61ad9f3fd4072a118402e97fe88d26c',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-kconfig',
    },
  },
  kdl = {
    install_info = {
      revision = 'b37e3d58e5c5cf8d739b315d6114e02d42e66664',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-kdl',
    },
  },
  kotlin = {
    install_info = {
      revision = '8d9d372b09fa4c3735657c5fc2ad03e53a5f05f5',
      url = 'https://github.com/fwcd/tree-sitter-kotlin',
    },
  },
  koto = {
    install_info = {
      revision = 'd4109879ba1387d19095269a7473bd7d274ab848',
      url = 'https://github.com/koto-lang/tree-sitter-koto',
    },
  },
  kusto = {
    install_info = {
      revision = '8353a1296607d6ba33db7c7e312226e5fc83e8ce',
      url = 'https://github.com/Willem-J-an/tree-sitter-kusto',
    },
  },
  lalrpop = {
    install_info = {
      revision = '854a40e99f7c70258e522bdb8ab584ede6196e2e',
      url = 'https://github.com/traxys/tree-sitter-lalrpop',
    },
  },
  latex = {
    install_info = {
      generate = true,
      revision = 'efe5afdbb59b70214e6d70db5197dc945d5b213e',
      url = 'https://github.com/latex-lsp/tree-sitter-latex',
    },
  },
  ledger = {
    install_info = {
      revision = '8a841fb20ce683bfbb3469e6ba67f2851cfdf94a',
      url = 'https://github.com/cbarrete/tree-sitter-ledger',
    },
  },
  leo = {
    install_info = {
      revision = '304611b5eaf53aca07459a0a03803b83b6dfd3b3',
      url = 'https://github.com/r001/tree-sitter-leo',
    },
  },
  linkerscript = {
    install_info = {
      revision = 'f99011a3554213b654985a4b0a65b3b032ec4621',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-linkerscript',
    },
  },
  liquid = {
    install_info = {
      revision = '7862a3424832c3a9d45eb21143b375837bd6573b',
      url = 'https://github.com/hankthetank27/tree-sitter-liquid',
    },
  },
  liquidsoap = {
    install_info = {
      revision = '14feafa91630afb1ab9988cf9b738b7ea29f3f89',
      url = 'https://github.com/savonet/tree-sitter-liquidsoap',
    },
  },
  llvm = {
    install_info = {
      revision = '1b96e58faf558ce057d4dc664b904528aee743cb',
      url = 'https://github.com/benwilliamgraham/tree-sitter-llvm',
    },
  },
  lua = {
    install_info = {
      revision = 'a24dab177e58c9c6832f96b9a73102a0cfbced4a',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-lua',
    },
  },
  luadoc = {
    install_info = {
      revision = '873612aadd3f684dd4e631bdf42ea8990c57634e',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-luadoc',
    },
  },
  luap = {
    install_info = {
      revision = 'c134aaec6acf4fa95fe4aa0dc9aba3eacdbbe55a',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-luap',
    },
  },
  luau = {
    install_info = {
      generate_from_json = true,
      revision = 'fbadc96272f718dba267628ba7b0e694c368cef3',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-luau',
    },
    requires = { 'lua' },
  },
  m68k = {
    install_info = {
      revision = 'e128454c2210c0e0c10b68fe45ddb8fee80182a3',
      url = 'https://github.com/grahambates/tree-sitter-m68k',
    },
  },
  make = {
    install_info = {
      revision = 'a4b9187417d6be349ee5fd4b6e77b4172c6827dd',
      url = 'https://github.com/alemuller/tree-sitter-make',
    },
  },
  markdown = {
    install_info = {
      location = 'tree-sitter-markdown',
      revision = '7fe453beacecf02c86f7736439f238f5bb8b5c9b',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-markdown',
    },
    requires = { 'markdown_inline' },
  },
  markdown_inline = {
    install_info = {
      location = 'tree-sitter-markdown-inline',
      revision = '7fe453beacecf02c86f7736439f238f5bb8b5c9b',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-markdown',
    },
  },
  matlab = {
    install_info = {
      revision = '0d5a05e543af2de60cdb5e71f0f5888c95ab936f',
      url = 'https://github.com/acristoffers/tree-sitter-matlab',
    },
  },
  menhir = {
    install_info = {
      revision = 'be8866a6bcc2b563ab0de895af69daeffa88fe70',
      url = 'https://github.com/Kerl13/tree-sitter-menhir',
    },
  },
  mermaid = {
    install_info = {
      revision = '90ae195b31933ceb9d079abfa8a3ad0a36fee4cc',
      url = 'https://github.com/monaqa/tree-sitter-mermaid',
    },
  },
  meson = {
    install_info = {
      revision = 'bd17c824196ce70800f64ad39cfddd1b17acc13f',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-meson',
    },
  },
  mlir = {
    install_info = {
      generate = true,
      revision = 'affbd6f3b08155826a22cfa8373147acbf60f1f1',
      url = 'https://github.com/artagnon/tree-sitter-mlir',
    },
  },
  muttrc = {
    install_info = {
      revision = '173b0ab53a9c07962c9777189c4c70e90f1c1837',
      url = 'https://github.com/neomutt/tree-sitter-muttrc',
    },
  },
  nasm = {
    install_info = {
      revision = '570f3d7be01fffc751237f4cfcf52d04e20532d1',
      url = 'https://github.com/naclsn/tree-sitter-nasm',
    },
  },
  nginx = {
    install_info = {
      revision = '281d184b8240b2b22670b8907b57b6d6842db6f3',
      url = 'https://github.com/opa-oz/tree-sitter-nginx',
    },
  },
  nickel = {
    install_info = {
      revision = '3039ad9e9af3c1ffe049a04ee83a2b489915b0b9',
      url = 'https://github.com/nickel-lang/tree-sitter-nickel',
    },
  },
  nim = {
    install_info = {
      revision = '897e5d346f0b59ed62b517cfb0f1a845ad8f0ab7',
      url = 'https://github.com/alaviss/tree-sitter-nim',
    },
    requires = { 'nim_format_string' },
  },
  nim_format_string = {
    install_info = {
      revision = 'd45f75022d147cda056e98bfba68222c9c8eca3a',
      url = 'https://github.com/aMOPel/tree-sitter-nim-format-string',
    },
  },
  ninja = {
    install_info = {
      revision = '0a95cfdc0745b6ae82f60d3a339b37f19b7b9267',
      url = 'https://github.com/alemuller/tree-sitter-ninja',
    },
  },
  nix = {
    install_info = {
      revision = '486bb0337ee94575f53367b53bffeaea99063f2c',
      url = 'https://github.com/cstrahan/tree-sitter-nix',
    },
  },
  nqc = {
    install_info = {
      generate_from_json = true,
      revision = '14e6da1627aaef21d2b2aa0c37d04269766dcc1d',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-nqc',
    },
  },
  objc = {
    install_info = {
      generate_from_json = true,
      revision = '62e61b6f5c0289c376d61a8c91faf6435cde9012',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-objc',
    },
    requires = { 'c' },
  },
  objdump = {
    install_info = {
      revision = '28d3b2e25a0b1881d1b47ed1924ca276c7003d45',
      url = 'https://github.com/ColinKennedy/tree-sitter-objdump',
    },
  },
  ocaml = {
    install_info = {
      location = 'grammars/ocaml',
      revision = '036226e5edb410aec004cc7ac0f4b2014dd04a0e',
      url = 'https://github.com/tree-sitter/tree-sitter-ocaml',
    },
  },
  ocaml_interface = {
    install_info = {
      location = 'grammars/interface',
      revision = '036226e5edb410aec004cc7ac0f4b2014dd04a0e',
      url = 'https://github.com/tree-sitter/tree-sitter-ocaml',
    },
    requires = { 'ocaml' },
  },
  ocamllex = {
    install_info = {
      generate = true,
      revision = '4b9898ccbf198602bb0dec9cd67cc1d2c0a4fad2',
      url = 'https://github.com/atom-ocaml/tree-sitter-ocamllex',
    },
  },
  odin = {
    install_info = {
      revision = 'd37b8f24f653378b268ec18404e9c14ad355b128',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-odin',
    },
  },
  org = {
    install_info = {
      revision = '64cfbc213f5a83da17632c95382a5a0a2f3357c1',
      url = 'https://github.com/milisims/tree-sitter-org',
    },
  },
  pascal = {
    install_info = {
      revision = 'd0ebabefaea9ac3f6fc3004cf08cd121b66da9e4',
      url = 'https://github.com/Isopod/tree-sitter-pascal',
    },
  },
  passwd = {
    install_info = {
      revision = '20239395eacdc2e0923a7e5683ad3605aee7b716',
      url = 'https://github.com/ath3/tree-sitter-passwd',
    },
  },
  pem = {
    install_info = {
      revision = '217ff2af3f2db15a79ab7e3d21ea1e0c17e71a1a',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-pem',
    },
  },
  perl = {
    install_info = {
      branch = 'release',
      generate_from_json = true,
      revision = '3a21d9cb2a20a062c17f8f53d5983fd473c4673c',
      url = 'https://github.com/tree-sitter-perl/tree-sitter-perl',
    },
  },
  php = {
    install_info = {
      location = 'php',
      revision = 'c07d69739ba71b5a449bdbb7735991f8aabf8546',
      url = 'https://github.com/tree-sitter/tree-sitter-php',
    },
    requires = { 'php_only' },
  },
  php_only = {
    install_info = {
      location = 'php_only',
      revision = 'c07d69739ba71b5a449bdbb7735991f8aabf8546',
      url = 'https://github.com/tree-sitter/tree-sitter-php',
    },
  },
  phpdoc = {
    install_info = {
      generate_from_json = true,
      revision = '1d0e255b37477d0ca46f1c9e9268c8fa76c0b3fc',
      url = 'https://github.com/claytonrcarter/tree-sitter-phpdoc',
    },
  },
  pioasm = {
    install_info = {
      revision = '924aadaf5dea2a6074d72027b064f939acf32e20',
      url = 'https://github.com/leo60228/tree-sitter-pioasm',
    },
  },
  po = {
    install_info = {
      revision = 'bd860a0f57f697162bf28e576674be9c1500db5e',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-po',
    },
  },
  pod = {
    install_info = {
      branch = 'release',
      generate_from_json = true,
      revision = '39da859947b94abdee43e431368e1ae975c0a424',
      url = 'https://github.com/tree-sitter-perl/tree-sitter-pod',
    },
  },
  poe_filter = {
    install_info = {
      revision = '592476d81f95d2451f2ca107dc872224c76fecdf',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-poe-filter',
    },
  },
  pony = {
    install_info = {
      revision = '73ff874ae4c9e9b45462673cbc0a1e350e2522a7',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-pony',
    },
  },
  powershell = {
    filetype = 'ps1',
    install_info = {
      revision = 'fc15514b2f1dbba9c58528d15a3708f89eda6a01',
      url = 'https://github.com/airbus-cert/tree-sitter-powershell',
    },
  },
  printf = {
    install_info = {
      revision = '0e0aceabbf607ea09e03562f5d8a56f048ddea3d',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-printf',
    },
  },
  prisma = {
    install_info = {
      revision = 'eca2596a355b1a9952b4f80f8f9caed300a272b5',
      url = 'https://github.com/victorhqc/tree-sitter-prisma',
    },
  },
  problog = {
    install_info = {
      location = 'grammars/problog',
      revision = '93c69d2f84d8a167c0a3f4a8d51ccefe365a4dc8',
      url = 'https://github.com/foxyseta/tree-sitter-prolog',
    },
    requires = { 'prolog' },
  },
  prolog = {
    install_info = {
      location = 'grammars/prolog',
      revision = '93c69d2f84d8a167c0a3f4a8d51ccefe365a4dc8',
      url = 'https://github.com/foxyseta/tree-sitter-prolog',
    },
  },
  promql = {
    install_info = {
      revision = '77625d78eebc3ffc44d114a07b2f348dff3061b0',
      url = 'https://github.com/MichaHoffmann/tree-sitter-promql',
    },
  },
  properties = {
    install_info = {
      revision = '9d09f5f200c356c50c4103d36441309fd61b48d1',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-properties',
    },
  },
  proto = {
    install_info = {
      revision = 'e9f6b43f6844bd2189b50a422d4e2094313f6aa3',
      url = 'https://github.com/treywood/tree-sitter-proto',
    },
  },
  prql = {
    install_info = {
      revision = '09e158cd3650581c0af4c49c2e5b10c4834c8646',
      url = 'https://github.com/PRQL/tree-sitter-prql',
    },
  },
  psv = {
    install_info = {
      location = 'psv',
      revision = '7eb7297823605392d2bbcc4c09b1cd18d6fa9529',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-csv',
    },
    requires = { 'tsv' },
  },
  pug = {
    install_info = {
      revision = 'a7ff31a38908df9b9f34828d21d6ca5e12413e18',
      url = 'https://github.com/zealot128/tree-sitter-pug',
    },
  },
  puppet = {
    install_info = {
      revision = '584522f32495d648b18a53ccb52d988e60de127d',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-puppet',
    },
  },
  purescript = {
    install_info = {
      revision = 'daf9b3e2be18b0b2996a1281f7783e0d041d8b80',
      url = 'https://github.com/postsolar/tree-sitter-purescript',
    },
  },
  pymanifest = {
    install_info = {
      revision = 'be062582956165019d3253794b4d712f66dfeaaa',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-pymanifest',
    },
    readme_name = 'PyPA manifest',
  },
  python = {
    install_info = {
      revision = '0dee05ef958ba2eae88d1e65f24b33cad70d4367',
      url = 'https://github.com/tree-sitter/tree-sitter-python',
    },
  },
  ql = {
    install_info = {
      revision = '42becd6f8f7bae82c818fa3abb1b6ff34b552310',
      url = 'https://github.com/tree-sitter/tree-sitter-ql',
    },
  },
  qmldir = {
    install_info = {
      revision = '6b2b5e41734bd6f07ea4c36ac20fb6f14061c841',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-qmldir',
    },
  },
  qmljs = {
    install_info = {
      generate_from_json = true,
      revision = 'febf48a5b6928600cd8fb2a01254743af550780d',
      url = 'https://github.com/yuja/tree-sitter-qmljs',
    },
    requires = { 'ecma' },
  },
  query = {
    install_info = {
      revision = 'f767fb0ac5e711b6d44c5e0c8d1f349687a86ce0',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-query',
    },
  },
  r = {
    install_info = {
      revision = 'b1e211f52ad8f8e1e182bbbcc16dcd5e3688eb7d',
      url = 'https://github.com/r-lib/tree-sitter-r',
    },
  },
  racket = {
    install_info = {
      revision = '171f52a8c0ed635b85cd42d1e36d82f1066a03b4',
      url = 'https://github.com/6cdh/tree-sitter-racket',
    },
  },
  ralph = {
    install_info = {
      revision = 'f6d81bf7a4599c77388035439cf5801cd461ff77',
      url = 'https://github.com/alephium/tree-sitter-ralph',
    },
  },
  rasi = {
    install_info = {
      revision = '6c9bbcfdf5f0f553d9ebc01750a3aa247a37b8aa',
      url = 'https://github.com/Fymyte/tree-sitter-rasi',
    },
  },
  rbs = {
    install_info = {
      revision = '8d8e65ac3f77fbc9e15b1cdb9f980a3e0ac3ab99',
      url = 'https://github.com/joker1007/tree-sitter-rbs',
    },
  },
  re2c = {
    install_info = {
      revision = '47aa19cf5f7aba2ed30e2b377f7172df76e819a6',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-re2c',
    },
  },
  readline = {
    install_info = {
      revision = '3d4768b04d7cfaf40533e12b28672603428b8f31',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-readline',
    },
  },
  regex = {
    install_info = {
      revision = '47007f195752d8e57bda80b0b6cdb2d173a9f7d7',
      url = 'https://github.com/tree-sitter/tree-sitter-regex',
    },
  },
  rego = {
    install_info = {
      revision = '20b5a5958c837bc9f74b231022a68a594a313f6d',
      url = 'https://github.com/FallenAngel97/tree-sitter-rego',
    },
  },
  requirements = {
    install_info = {
      revision = '5ad9b7581b3334f6ad492847d007f2fac6e6e5f2',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-requirements',
    },
    readme_name = 'pip requirements',
  },
  rescript = {
    install_info = {
      revision = '4606cd81c4c31d1d02390fee530858323410a74c',
      url = 'https://github.com/rescript-lang/tree-sitter-rescript',
    },
  },
  rnoweb = {
    install_info = {
      revision = '1a74dc0ed731ad07db39f063e2c5a6fe528cae7f',
      url = 'https://github.com/bamonroe/tree-sitter-rnoweb',
    },
  },
  robot = {
    install_info = {
      revision = '322e4cc65754d2b3fdef4f2f8a71e0762e3d13af',
      url = 'https://github.com/Hubro/tree-sitter-robot',
    },
  },
  robots = {
    install_info = {
      revision = '8e3a4205b76236bb6dbebdbee5afc262ce38bb62',
      url = 'https://github.com/opa-oz/tree-sitter-robots-txt',
    },
  },
  roc = {
    install_info = {
      revision = 'ef46edd0c03ea30a22f7e92bc68628fb7231dc8a',
      url = 'https://github.com/faldor20/tree-sitter-roc',
    },
  },
  ron = {
    install_info = {
      revision = '78938553b93075e638035f624973083451b29055',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-ron',
    },
  },
  rst = {
    install_info = {
      revision = '5120f6e59284cb8b85b450bd2db0bd352635ba9f',
      url = 'https://github.com/stsewd/tree-sitter-rst',
    },
  },
  ruby = {
    install_info = {
      revision = '0ffe457fb6aabf064f173fd30ea356845cef2513',
      url = 'https://github.com/tree-sitter/tree-sitter-ruby',
    },
  },
  rust = {
    install_info = {
      revision = '9c84af007b0f144954adb26b3f336495cbb320a7',
      url = 'https://github.com/tree-sitter/tree-sitter-rust',
    },
  },
  scala = {
    install_info = {
      revision = 'be7184df70dd3b5790becfb2c93ba796b2797781',
      url = 'https://github.com/tree-sitter/tree-sitter-scala',
    },
  },
  scfg = {
    install_info = {
      generate = true,
      revision = 'a5512800ea0220da4abbae61b8aea8423d1549aa',
      url = 'https://github.com/rockorager/tree-sitter-scfg',
    },
  },
  scheme = {
    install_info = {
      revision = '8f9dff3d038f09934db5ea113cebc59c74447743',
      url = 'https://github.com/6cdh/tree-sitter-scheme',
    },
  },
  scss = {
    install_info = {
      revision = 'c478c6868648eff49eb04a4df90d703dc45b312a',
      url = 'https://github.com/serenadeai/tree-sitter-scss',
    },
    requires = { 'css' },
  },
  slang = {
    install_info = {
      generate_from_json = true,
      revision = 'd84b43d75d65bbc4ba57166ce17555f32c0b8983',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-slang',
    },
  },
  slint = {
    install_info = {
      revision = '4a0558cc0fcd7a6110815b9bbd7cc12d7ab31e74',
      url = 'https://github.com/slint-ui/tree-sitter-slint',
    },
  },
  smali = {
    install_info = {
      revision = 'fdfa6a1febc43c7467aa7e937b87b607956f2346',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-smali',
    },
  },
  smithy = {
    install_info = {
      revision = 'fa898ac0885d1da9a253695c3e0e91f5efc587cd',
      url = 'https://github.com/indoorvivants/tree-sitter-smithy',
    },
  },
  snakemake = {
    install_info = {
      generate_from_json = true,
      revision = 'e909815acdbe37e69440261ebb1091ed52e1dec6',
      url = 'https://github.com/osthomas/tree-sitter-snakemake',
    },
  },
  solidity = {
    install_info = {
      revision = 'ee5a2d2ba30b487c4bbf613d2ef310a454c09c7c',
      url = 'https://github.com/JoranHonig/tree-sitter-solidity',
    },
  },
  soql = {
    install_info = {
      location = 'soql',
      revision = 'caffc6ebd1ab16ba4d4dec367cebb03ca2411872',
      url = 'https://github.com/aheber/tree-sitter-sfapex',
    },
  },
  sosl = {
    install_info = {
      location = 'sosl',
      revision = 'caffc6ebd1ab16ba4d4dec367cebb03ca2411872',
      url = 'https://github.com/aheber/tree-sitter-sfapex',
    },
  },
  sourcepawn = {
    install_info = {
      revision = '6b9bf9cbab91443380d2ca8a2f6c491cc7fac5bf',
      url = 'https://github.com/nilshelmig/tree-sitter-sourcepawn',
    },
  },
  sparql = {
    install_info = {
      generate_from_json = true,
      revision = 'd853661ca680d8ff7f8d800182d5782b61d0dd58',
      url = 'https://github.com/GordianDziwis/tree-sitter-sparql',
    },
  },
  sql = {
    install_info = {
      branch = 'gh-pages',
      generate_from_json = true,
      revision = '3f51da54347f4561541c71b0d384ca3ef3b38d9d',
      url = 'https://github.com/derekstride/tree-sitter-sql',
    },
  },
  squirrel = {
    install_info = {
      revision = '072c969749e66f000dba35a33c387650e203e96e',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-squirrel',
    },
  },
  ssh_config = {
    install_info = {
      revision = '77450e8bce8853921512348f83c73c168c71fdfb',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-ssh-config',
    },
  },
  starlark = {
    install_info = {
      generate_from_json = true,
      revision = '018d0e09d9d0f0dd6740a37682b8ee4512e8b2ac',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-starlark',
    },
  },
  strace = {
    install_info = {
      revision = 'd819cdd5dbe455bd3c859193633c8d91c0df7c36',
      url = 'https://github.com/sigmaSd/tree-sitter-strace',
    },
  },
  styled = {
    install_info = {
      generate_from_json = true,
      revision = '65835cca33a5f033bcde580ed66cde01c1fabbbe',
      url = 'https://github.com/mskelton/tree-sitter-styled',
    },
  },
  supercollider = {
    install_info = {
      revision = 'affa4389186b6939d89673e1e9d2b28364f5ca6f',
      url = 'https://github.com/madskjeldgaard/tree-sitter-supercollider',
    },
  },
  surface = {
    install_info = {
      revision = 'f4586b35ac8548667a9aaa4eae44456c1f43d032',
      url = 'https://github.com/connorlay/tree-sitter-surface',
    },
  },
  svelte = {
    install_info = {
      generate_from_json = true,
      revision = '7ab8221e3f378a3b04b4b488f07c1f408c5bd0d8',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-svelte',
    },
    requires = { 'html_tags' },
  },
  swift = {
    install_info = {
      generate = true,
      revision = '769bb834feb2947f2c706d82830b0a05958727de',
      url = 'https://github.com/alex-pinkus/tree-sitter-swift',
    },
  },
  sxhkdrc = {
    install_info = {
      revision = '440d5f913d9465c9c776a1bd92334d32febcf065',
      url = 'https://github.com/RaafatTurki/tree-sitter-sxhkdrc',
    },
  },
  systemtap = {
    install_info = {
      revision = 'f2b378a9af0b7e1192cff67a5fb45508c927205d',
      url = 'https://github.com/ok-ryoko/tree-sitter-systemtap',
    },
  },
  systemverilog = {
    install_info = {
      revision = '4f897d5e3f0e38bf8fbb55e8f39dc97d2bc2229e',
      url = 'https://github.com/zhangwwpeng/tree-sitter-systemverilog',
    },
  },
  t32 = {
    install_info = {
      revision = '6182836f4128725f1e74ce986840d7317021a015',
      url = 'https://gitlab.com/xasc/tree-sitter-t32',
    },
  },
  tablegen = {
    install_info = {
      revision = 'b1170880c61355aaf38fc06f4af7d3c55abdabc4',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-tablegen',
    },
  },
  tact = {
    install_info = {
      revision = '91cc49a83f4f0b3a756bf7d0e65403a9cf757003',
      url = 'https://github.com/tact-lang/tree-sitter-tact',
    },
  },
  tcl = {
    install_info = {
      revision = '8784024358c233efd0f3a6fd9e7a3c5852e628bc',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-tcl',
    },
  },
  teal = {
    install_info = {
      generate = true,
      revision = '19b02da829d1721a521bf7b802eb80a50bd53aab',
      url = 'https://github.com/euclidianAce/tree-sitter-teal',
    },
  },
  templ = {
    install_info = {
      generate_from_json = true,
      revision = 'de0d0ee129cf643872e8e0d5c4a6589b5a3aae23',
      url = 'https://github.com/vrischmann/tree-sitter-templ',
    },
  },
  terraform = {
    install_info = {
      location = 'dialects/terraform',
      revision = '9e3ec9848f28d26845ba300fd73c740459b83e9b',
      url = 'https://github.com/MichaHoffmann/tree-sitter-hcl',
    },
    requires = { 'hcl' },
  },
  textproto = {
    install_info = {
      revision = '8dacf02aa402892c91079f8577998ed5148c0496',
      url = 'https://github.com/PorterAtGoogle/tree-sitter-textproto',
    },
  },
  thrift = {
    install_info = {
      revision = '68fd0d80943a828d9e6f49c58a74be1e9ca142cf',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-thrift',
    },
  },
  tiger = {
    install_info = {
      revision = 'a7f11d946b44244f71df41d2a78af0665d618dae',
      url = 'https://github.com/ambroisie/tree-sitter-tiger',
    },
  },
  tlaplus = {
    install_info = {
      revision = 'bba02e79f85e335f310fc95e21c677e49f2c4439',
      url = 'https://github.com/tlaplus-community/tree-sitter-tlaplus',
    },
  },
  tmux = {
    install_info = {
      revision = '0252ecd080016e45e6305ef1a943388f5ae2f4b4',
      url = 'https://github.com/Freed-Wu/tree-sitter-tmux',
    },
  },
  todotxt = {
    install_info = {
      revision = '3937c5cd105ec4127448651a21aef45f52d19609',
      url = 'https://github.com/arnarg/tree-sitter-todotxt',
    },
  },
  toml = {
    install_info = {
      generate_from_json = true,
      revision = '16a30c83ce427385b8d14939c45c137fcfca6c42',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-toml',
    },
  },
  tsv = {
    install_info = {
      location = 'tsv',
      revision = '7eb7297823605392d2bbcc4c09b1cd18d6fa9529',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-csv',
    },
  },
  tsx = {
    install_info = {
      generate_from_json = true,
      location = 'tsx',
      revision = '198d03553f43a45b92ac5d0ee167db3fec6a6fd6',
      url = 'https://github.com/tree-sitter/tree-sitter-typescript',
    },
    requires = { 'ecma', 'jsx', 'typescript' },
  },
  turtle = {
    install_info = {
      revision = '7f789ea7ef765080f71a298fc96b7c957fa24422',
      url = 'https://github.com/GordianDziwis/tree-sitter-turtle',
    },
  },
  twig = {
    install_info = {
      revision = '085648e01d1422163a1702a44e72303b4e2a0bd1',
      url = 'https://github.com/gbprod/tree-sitter-twig',
    },
  },
  typescript = {
    install_info = {
      generate_from_json = true,
      location = 'typescript',
      revision = '198d03553f43a45b92ac5d0ee167db3fec6a6fd6',
      url = 'https://github.com/tree-sitter/tree-sitter-typescript',
    },
    requires = { 'ecma' },
  },
  typespec = {
    install_info = {
      revision = '0ee05546d73d8eb64635ed8125de6f35c77759fe',
      url = 'https://github.com/happenslol/tree-sitter-typespec',
    },
  },
  typoscript = {
    install_info = {
      revision = '43b221c0b76e77244efdaa9963e402a17c930fbc',
      url = 'https://github.com/Teddytrombone/tree-sitter-typoscript',
    },
  },
  typst = {
    install_info = {
      revision = 'abe60cbed7986ee475d93f816c1be287f220c5d8',
      url = 'https://github.com/uben0/tree-sitter-typst',
    },
  },
  udev = {
    install_info = {
      revision = '8f58696e79092b4ad6bf197415bbd0970acf15cd',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-udev',
    },
  },
  ungrammar = {
    install_info = {
      revision = 'debd26fed283d80456ebafa33a06957b0c52e451',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-ungrammar',
    },
  },
  unison = {
    install_info = {
      generate = true,
      revision = '59d36a09282be7e4d3374854126590f3dcebee6e',
      url = 'https://github.com/kylegoetz/tree-sitter-unison',
    },
  },
  usd = {
    install_info = {
      revision = '4e0875f724d94d0c2ff36f9b8cb0b12f8b20d216',
      url = 'https://github.com/ColinKennedy/tree-sitter-usd',
    },
  },
  uxntal = {
    install_info = {
      revision = 'ad9b638b914095320de85d59c49ab271603af048',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-uxntal',
    },
  },
  v = {
    install_info = {
      location = 'tree_sitter_v',
      revision = '7f80a0441ff2ca6aa8ced8e1ee87cead9dd26515',
      url = 'https://github.com/vlang/v-analyzer',
    },
  },
  vala = {
    install_info = {
      revision = '8f690bfa639f2b83d1fb938ed3dd98a7ba453e8b',
      url = 'https://github.com/vala-lang/tree-sitter-vala',
    },
  },
  vento = {
    install_info = {
      revision = '3321077d7446c1b3b017c294fd56ce028ed817fe',
      url = 'https://github.com/ventojs/tree-sitter-vento',
    },
  },
  verilog = {
    install_info = {
      revision = '075ebfc84543675f12e79a955f79d717772dcef3',
      url = 'https://github.com/tree-sitter/tree-sitter-verilog',
    },
  },
  vhdl = {
    install_info = {
      revision = '4ab3e251eae8890a020d083d00acd1b8c2653c07',
      url = 'https://github.com/jpt13653903/tree-sitter-vhdl',
    },
  },
  vhs = {
    install_info = {
      revision = '90028bbadb267ead5b87830380f6a825147f0c0f',
      url = 'https://github.com/charmbracelet/tree-sitter-vhs',
    },
  },
  vim = {
    install_info = {
      revision = 'f3cd62d8bd043ef20507e84bb6b4b53731ccf3a7',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-vim',
    },
  },
  vimdoc = {
    install_info = {
      revision = '2249c44ecd3f5cf22da3dcccfb74f816ddb29245',
      url = 'https://github.com/neovim/tree-sitter-vimdoc',
    },
  },
  vrl = {
    install_info = {
      revision = '274b3ce63f72aa8ffea18e7fc280d3062d28f0ba',
      url = 'https://github.com/belltoy/tree-sitter-vrl',
    },
  },
  vue = {
    install_info = {
      branch = 'main',
      generate_from_json = true,
      revision = '22bdfa6c9fc0f5ffa44c6e938ec46869ac8a99ff',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-vue',
    },
    requires = { 'html_tags' },
  },
  wgsl = {
    install_info = {
      revision = '40259f3c77ea856841a4e0c4c807705f3e4a2b65',
      url = 'https://github.com/szebniok/tree-sitter-wgsl',
    },
  },
  wgsl_bevy = {
    install_info = {
      generate_from_json = true,
      revision = '0f06f24e259ac725045956436b9025dab008ff9f',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-wgsl-bevy',
    },
  },
  wing = {
    install_info = {
      revision = 'bd1d35cf3e013dc7e189b46a593bdc2b281b0dd7',
      url = 'https://github.com/winglang/tree-sitter-wing',
    },
  },
  wit = {
    install_info = {
      revision = 'c52f0b07786603df17ad0197f6cef680f312eb2c',
      url = 'https://github.com/liamwh/tree-sitter-wit',
    },
  },
  xcompose = {
    install_info = {
      revision = 'fff3e72242aa110ebba6441946ea4d12d200fa68',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-xcompose',
    },
  },
  xml = {
    install_info = {
      location = 'xml',
      revision = '809266ed1694d64dedc168a18893cc254e3edf7e',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-xml',
    },
    requires = { 'dtd' },
  },
  yaml = {
    install_info = {
      revision = '7b03feefd36b5f155465ca736c6304aca983b267',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-yaml',
    },
  },
  yang = {
    install_info = {
      revision = '2c0e6be8dd4dcb961c345fa35c309ad4f5bd3502',
      url = 'https://github.com/Hubro/tree-sitter-yang',
    },
  },
  yuck = {
    install_info = {
      revision = 'e877f6ade4b77d5ef8787075141053631ba12318',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-yuck',
    },
  },
  zathurarc = {
    install_info = {
      revision = '0554b4a5d313244b7fc000cbb41c04afae4f4e31',
      url = 'https://github.com/Freed-Wu/tree-sitter-zathurarc',
    },
  },
  zig = {
    install_info = {
      revision = '2bac4cc6c697d46a193905fef6d003bfa0bfabfd',
      url = 'https://github.com/maxxnino/tree-sitter-zig',
    },
  },
}
