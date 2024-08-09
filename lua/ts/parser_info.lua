--- @type table<string,ts.ParserInfo>
return {
  ada = {
    install_info = {
      url = 'https://github.com/briot/tree-sitter-ada',
    },
  },
  agda = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-agda',
    },
  },
  angular = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/dlvandenberg/tree-sitter-angular',
    },
    requires = { 'html', 'html_tags' },
  },
  apex = {
    install_info = {
      location = 'apex',
      url = 'https://github.com/aheber/tree-sitter-sfapex',
    },
  },
  arduino = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-arduino',
    },
    requires = { 'cpp' },
  },
  asm = {
    install_info = {
      url = 'https://github.com/RubixDev/tree-sitter-asm',
    },
  },
  astro = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/virchau13/tree-sitter-astro',
    },
    requires = { 'html', 'html_tags' },
  },
  authzed = {
    install_info = {
      url = 'https://github.com/mleonidas/tree-sitter-authzed',
    },
  },
  awk = {
    install_info = {
      url = 'https://github.com/Beaglefoot/tree-sitter-awk',
    },
  },
  bash = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-bash',
    },
  },
  bass = {
    install_info = {
      url = 'https://github.com/vito/tree-sitter-bass',
    },
  },
  beancount = {
    install_info = {
      url = 'https://github.com/polarmutex/tree-sitter-beancount',
    },
  },
  bibtex = {
    install_info = {
      url = 'https://github.com/latex-lsp/tree-sitter-bibtex',
    },
  },
  bicep = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-bicep',
    },
  },
  bitbake = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-bitbake',
    },
  },
  blueprint = {
    install_info = {
      url = 'https://gitlab.com/gabmus/tree-sitter-blueprint',
    },
  },
  bp = {
    install_info = {
      url = 'https://github.com/ambroisie/tree-sitter-bp',
    },
  },
  c = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-c',
    },
  },
  c_sharp = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-c-sharp',
    },
  },
  cairo = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-cairo',
    },
  },
  capnp = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-capnp',
    },
  },
  chatito = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-chatito',
    },
  },
  clojure = {
    install_info = {
      url = 'https://github.com/sogaiu/tree-sitter-clojure',
    },
  },
  cmake = {
    install_info = {
      url = 'https://github.com/uyha/tree-sitter-cmake',
    },
  },
  comment = {
    install_info = {
      url = 'https://github.com/stsewd/tree-sitter-comment',
    },
  },
  commonlisp = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-commonlisp',
    },
  },
  cooklang = {
    install_info = {
      url = 'https://github.com/addcninblue/tree-sitter-cooklang',
    },
  },
  corn = {
    install_info = {
      url = 'https://github.com/jakestanger/tree-sitter-corn',
    },
  },
  cpon = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-cpon',
    },
  },
  cpp = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter/tree-sitter-cpp',
    },
    requires = { 'c' },
  },
  css = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-css',
    },
  },
  csv = {
    install_info = {
      location = 'csv',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-csv',
    },
    requires = { 'tsv' },
  },
  cuda = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-cuda',
    },
    requires = { 'cpp' },
  },
  cue = {
    install_info = {
      url = 'https://github.com/eonpatapon/tree-sitter-cue',
    },
  },
  d = {
    install_info = {
      url = 'https://github.com/gdamore/tree-sitter-d',
    },
  },
  dart = {
    install_info = {
      url = 'https://github.com/UserNobody14/tree-sitter-dart',
    },
  },
  devicetree = {
    install_info = {
      url = 'https://github.com/joelspadin/tree-sitter-devicetree',
    },
  },
  dhall = {
    install_info = {
      url = 'https://github.com/jbellerb/tree-sitter-dhall',
    },
  },
  diff = {
    install_info = {
      url = 'https://github.com/the-mikedavis/tree-sitter-diff',
    },
  },
  disassembly = {
    install_info = {
      url = 'https://github.com/ColinKennedy/tree-sitter-disassembly',
    },
  },
  djot = {
    install_info = {
      url = 'https://github.com/treeman/tree-sitter-djot',
    },
  },
  dockerfile = {
    install_info = {
      url = 'https://github.com/camdencheek/tree-sitter-dockerfile',
    },
  },
  dot = {
    install_info = {
      url = 'https://github.com/rydesun/tree-sitter-dot',
    },
  },
  doxygen = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-doxygen',
    },
  },
  dtd = {
    install_info = {
      location = 'dtd',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-xml',
    },
  },
  earthfile = {
    install_info = {
      url = 'https://github.com/glehmann/tree-sitter-earthfile',
    },
  },
  ebnf = {
    install_info = {
      location = 'crates/tree-sitter-ebnf',
      url = 'https://github.com/RubixDev/ebnf',
    },
  },
  editorconfig = {
    install_info = {
      url = 'https://github.com/ValdezFOmar/tree-sitter-editorconfig',
    },
  },
  eds = {
    install_info = {
      url = 'https://github.com/uyha/tree-sitter-eds',
    },
  },
  eex = {
    install_info = {
      url = 'https://github.com/connorlay/tree-sitter-eex',
    },
  },
  elixir = {
    install_info = {
      url = 'https://github.com/elixir-lang/tree-sitter-elixir',
    },
  },
  elm = {
    install_info = {
      url = 'https://github.com/elm-tooling/tree-sitter-elm',
    },
  },
  elsa = {
    install_info = {
      url = 'https://github.com/glapa-grossklag/tree-sitter-elsa',
    },
  },
  elvish = {
    install_info = {
      url = 'https://github.com/elves/tree-sitter-elvish',
    },
  },
  embedded_template = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-embedded-template',
    },
  },
  erlang = {
    install_info = {
      url = 'https://github.com/WhatsApp/tree-sitter-erlang',
    },
  },
  facility = {
    install_info = {
      url = 'https://github.com/FacilityApi/tree-sitter-facility',
    },
  },
  faust = {
    install_info = {
      url = 'https://github.com/khiner/tree-sitter-faust',
    },
  },
  fennel = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/alexmozaidze/tree-sitter-fennel',
    },
  },
  fidl = {
    install_info = {
      url = 'https://github.com/google/tree-sitter-fidl',
    },
  },
  firrtl = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-firrtl',
    },
  },
  fish = {
    install_info = {
      url = 'https://github.com/ram02z/tree-sitter-fish',
    },
  },
  foam = {
    install_info = {
      url = 'https://github.com/FoamScience/tree-sitter-foam',
    },
  },
  forth = {
    install_info = {
      url = 'https://github.com/AlexanderBrevig/tree-sitter-forth',
    },
  },
  fortran = {
    install_info = {
      url = 'https://github.com/stadelmanma/tree-sitter-fortran',
    },
  },
  fsh = {
    install_info = {
      url = 'https://github.com/mgramigna/tree-sitter-fsh',
    },
  },
  func = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-func',
    },
  },
  fusion = {
    install_info = {
      url = 'https://gitlab.com/jirgn/tree-sitter-fusion',
    },
  },
  gdscript = {
    install_info = {
      url = 'https://github.com/PrestonKnopp/tree-sitter-gdscript',
    },
  },
  gdshader = {
    install_info = {
      url = 'https://github.com/GodOfAvacyn/tree-sitter-gdshader',
    },
  },
  git_config = {
    install_info = {
      url = 'https://github.com/the-mikedavis/tree-sitter-git-config',
    },
  },
  git_rebase = {
    install_info = {
      url = 'https://github.com/the-mikedavis/tree-sitter-git-rebase',
    },
  },
  gitattributes = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-gitattributes',
    },
  },
  gitcommit = {
    install_info = {
      url = 'https://github.com/gbprod/tree-sitter-gitcommit',
    },
  },
  gitignore = {
    install_info = {
      url = 'https://github.com/shunsambongi/tree-sitter-gitignore',
    },
  },
  gleam = {
    install_info = {
      url = 'https://github.com/gleam-lang/tree-sitter-gleam',
    },
  },
  glimmer = {
    install_info = {
      url = 'https://github.com/alexlafroscia/tree-sitter-glimmer',
    },
  },
  glsl = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-glsl',
    },
    requires = { 'c' },
  },
  gn = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-gn',
    },
    readme_name = 'GN (Generate Ninja)',
  },
  gnuplot = {
    install_info = {
      url = 'https://github.com/dpezto/tree-sitter-gnuplot',
    },
  },
  go = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-go',
    },
  },
  goctl = {
    install_info = {
      url = 'https://github.com/chaozwn/tree-sitter-goctl',
    },
  },
  godot_resource = {
    install_info = {
      url = 'https://github.com/PrestonKnopp/tree-sitter-godot-resource',
    },
  },
  gomod = {
    install_info = {
      url = 'https://github.com/camdencheek/tree-sitter-go-mod',
    },
  },
  gosum = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-go-sum',
    },
  },
  gotmpl = {
    install_info = {
      url = 'https://github.com/ngalaiko/tree-sitter-go-template',
    },
  },
  gowork = {
    install_info = {
      url = 'https://github.com/omertuc/tree-sitter-go-work',
    },
  },
  gpg = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-gpg-config',
    },
  },
  graphql = {
    install_info = {
      url = 'https://github.com/bkegley/tree-sitter-graphql',
    },
  },
  groovy = {
    install_info = {
      url = 'https://github.com/murtaza64/tree-sitter-groovy',
    },
  },
  gstlaunch = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-gstlaunch',
    },
  },
  hack = {
    install_info = {
      url = 'https://github.com/slackhq/tree-sitter-hack',
    },
  },
  hare = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-hare',
    },
  },
  haskell = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-haskell',
    },
  },
  haskell_persistent = {
    install_info = {
      url = 'https://github.com/MercuryTechnologies/tree-sitter-haskell-persistent',
    },
  },
  hcl = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-hcl',
    },
  },
  heex = {
    install_info = {
      url = 'https://github.com/connorlay/tree-sitter-heex',
    },
  },
  helm = {
    install_info = {
      location = 'dialects/helm',
      url = 'https://github.com/ngalaiko/tree-sitter-go-template',
    },
  },
  hjson = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/winston0410/tree-sitter-hjson',
    },
    requires = { 'json' },
  },
  hlsl = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-hlsl',
    },
    requires = { 'cpp' },
  },
  hlsplaylist = {
    install_info = {
      url = 'https://github.com/Freed-Wu/tree-sitter-hlsplaylist',
    },
  },
  hocon = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/antosha417/tree-sitter-hocon',
    },
  },
  hoon = {
    install_info = {
      url = 'https://github.com/urbit-pilled/tree-sitter-hoon',
    },
  },
  html = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-html',
    },
    requires = { 'html_tags' },
  },
  html_tags = {},
  htmldjango = {
    install_info = {
      url = 'https://github.com/interdependence/tree-sitter-htmldjango',
    },
  },
  http = {
    install_info = {
      url = 'https://github.com/rest-nvim/tree-sitter-http',
    },
  },
  hurl = {
    install_info = {
      url = 'https://github.com/pfeiferj/tree-sitter-hurl',
    },
  },
  hyprlang = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-hyprlang',
    },
  },
  idl = {
    install_info = {
      url = 'https://github.com/cathaysia/tree-sitter-idl',
    },
  },
  ini = {
    install_info = {
      url = 'https://github.com/justinmk/tree-sitter-ini',
    },
  },
  inko = {
    install_info = {
      url = 'https://github.com/inko-lang/tree-sitter-inko',
    },
  },
  ispc = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-ispc',
    },
    requires = { 'c' },
  },
  janet_simple = {
    install_info = {
      url = 'https://github.com/sogaiu/tree-sitter-janet-simple',
    },
  },
  java = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-java',
    },
  },
  javascript = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-javascript',
    },
    requires = { 'ecma', 'jsx' },
  },
  jq = {
    install_info = {
      url = 'https://github.com/flurie/tree-sitter-jq',
    },
  },
  jsdoc = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-jsdoc',
    },
  },
  json = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-json',
    },
  },
  json5 = {
    install_info = {
      url = 'https://github.com/Joakker/tree-sitter-json5',
    },
  },
  jsonc = {
    install_info = {
      generate_from_json = true,
      url = 'https://gitlab.com/WhyNotHugo/tree-sitter-jsonc',
    },
    requires = { 'json' },
  },
  jsonnet = {
    install_info = {
      url = 'https://github.com/sourcegraph/tree-sitter-jsonnet',
    },
  },
  jsx = {},
  julia = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-julia',
    },
  },
  just = {
    install_info = {
      url = 'https://github.com/IndianBoy42/tree-sitter-just',
    },
  },
  kconfig = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-kconfig',
    },
  },
  kdl = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-kdl',
    },
  },
  kotlin = {
    install_info = {
      url = 'https://github.com/fwcd/tree-sitter-kotlin',
    },
  },
  koto = {
    install_info = {
      url = 'https://github.com/koto-lang/tree-sitter-koto',
    },
  },
  kusto = {
    install_info = {
      url = 'https://github.com/Willem-J-an/tree-sitter-kusto',
    },
  },
  lalrpop = {
    install_info = {
      url = 'https://github.com/traxys/tree-sitter-lalrpop',
    },
  },
  latex = {
    install_info = {
      generate = true,
      url = 'https://github.com/latex-lsp/tree-sitter-latex',
    },
  },
  ledger = {
    install_info = {
      url = 'https://github.com/cbarrete/tree-sitter-ledger',
    },
  },
  leo = {
    install_info = {
      url = 'https://github.com/r001/tree-sitter-leo',
    },
  },
  linkerscript = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-linkerscript',
    },
  },
  liquid = {
    install_info = {
      url = 'https://github.com/hankthetank27/tree-sitter-liquid',
    },
  },
  liquidsoap = {
    install_info = {
      url = 'https://github.com/savonet/tree-sitter-liquidsoap',
    },
  },
  llvm = {
    install_info = {
      url = 'https://github.com/benwilliamgraham/tree-sitter-llvm',
    },
  },
  lua = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-lua',
    },
  },
  luadoc = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-luadoc',
    },
  },
  luap = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-luap',
    },
  },
  luau = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-luau',
    },
    requires = { 'lua' },
  },
  m68k = {
    install_info = {
      url = 'https://github.com/grahambates/tree-sitter-m68k',
    },
  },
  make = {
    install_info = {
      url = 'https://github.com/alemuller/tree-sitter-make',
    },
  },
  markdown = {
    install_info = {
      location = 'tree-sitter-markdown',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-markdown',
    },
    requires = { 'markdown_inline' },
  },
  markdown_inline = {
    install_info = {
      location = 'tree-sitter-markdown-inline',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-markdown',
    },
  },
  matlab = {
    install_info = {
      url = 'https://github.com/acristoffers/tree-sitter-matlab',
    },
  },
  menhir = {
    install_info = {
      url = 'https://github.com/Kerl13/tree-sitter-menhir',
    },
  },
  mermaid = {
    install_info = {
      url = 'https://github.com/monaqa/tree-sitter-mermaid',
    },
  },
  meson = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-meson',
    },
  },
  mlir = {
    install_info = {
      generate = true,
      url = 'https://github.com/artagnon/tree-sitter-mlir',
    },
  },
  muttrc = {
    install_info = {
      url = 'https://github.com/neomutt/tree-sitter-muttrc',
    },
  },
  nasm = {
    install_info = {
      url = 'https://github.com/naclsn/tree-sitter-nasm',
    },
  },
  nginx = {
    install_info = {
      url = 'https://github.com/opa-oz/tree-sitter-nginx',
    },
  },
  nickel = {
    install_info = {
      url = 'https://github.com/nickel-lang/tree-sitter-nickel',
    },
  },
  nim = {
    install_info = {
      url = 'https://github.com/alaviss/tree-sitter-nim',
    },
    requires = { 'nim_format_string' },
  },
  nim_format_string = {
    install_info = {
      url = 'https://github.com/aMOPel/tree-sitter-nim-format-string',
    },
  },
  ninja = {
    install_info = {
      url = 'https://github.com/alemuller/tree-sitter-ninja',
    },
  },
  nix = {
    install_info = {
      url = 'https://github.com/cstrahan/tree-sitter-nix',
    },
  },
  nqc = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-nqc',
    },
  },
  objc = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-objc',
    },
    requires = { 'c' },
  },
  objdump = {
    install_info = {
      url = 'https://github.com/ColinKennedy/tree-sitter-objdump',
    },
  },
  ocaml = {
    install_info = {
      location = 'grammars/ocaml',
      url = 'https://github.com/tree-sitter/tree-sitter-ocaml',
    },
  },
  ocaml_interface = {
    install_info = {
      location = 'grammars/interface',
      url = 'https://github.com/tree-sitter/tree-sitter-ocaml',
    },
    requires = { 'ocaml' },
  },
  ocamllex = {
    install_info = {
      generate = true,
      url = 'https://github.com/atom-ocaml/tree-sitter-ocamllex',
    },
  },
  odin = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-odin',
    },
  },
  org = {
    install_info = {
      url = 'https://github.com/milisims/tree-sitter-org',
    },
  },
  pascal = {
    install_info = {
      url = 'https://github.com/Isopod/tree-sitter-pascal',
    },
  },
  passwd = {
    install_info = {
      url = 'https://github.com/ath3/tree-sitter-passwd',
    },
  },
  pem = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-pem',
    },
  },
  perl = {
    install_info = {
      branch = 'release',
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-perl/tree-sitter-perl',
    },
  },
  php = {
    install_info = {
      location = 'php',
      url = 'https://github.com/tree-sitter/tree-sitter-php',
    },
    requires = { 'php_only' },
  },
  php_only = {
    install_info = {
      location = 'php_only',
      url = 'https://github.com/tree-sitter/tree-sitter-php',
    },
  },
  phpdoc = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/claytonrcarter/tree-sitter-phpdoc',
    },
  },
  pioasm = {
    install_info = {
      url = 'https://github.com/leo60228/tree-sitter-pioasm',
    },
  },
  po = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-po',
    },
  },
  pod = {
    install_info = {
      branch = 'release',
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-perl/tree-sitter-pod',
    },
  },
  poe_filter = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-poe-filter',
    },
  },
  pony = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-pony',
    },
  },
  powershell = {
    filetype = 'ps1',
    install_info = {
      url = 'https://github.com/airbus-cert/tree-sitter-powershell',
    },
  },
  printf = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-printf',
    },
  },
  prisma = {
    install_info = {
      url = 'https://github.com/victorhqc/tree-sitter-prisma',
    },
  },
  problog = {
    install_info = {
      location = 'grammars/problog',
      url = 'https://github.com/foxyseta/tree-sitter-prolog',
    },
    requires = { 'prolog' },
  },
  prolog = {
    install_info = {
      location = 'grammars/prolog',
      url = 'https://github.com/foxyseta/tree-sitter-prolog',
    },
  },
  promql = {
    install_info = {
      url = 'https://github.com/MichaHoffmann/tree-sitter-promql',
    },
  },
  properties = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-properties',
    },
  },
  proto = {
    install_info = {
      url = 'https://github.com/treywood/tree-sitter-proto',
    },
  },
  prql = {
    install_info = {
      url = 'https://github.com/PRQL/tree-sitter-prql',
    },
  },
  psv = {
    install_info = {
      location = 'psv',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-csv',
    },
    requires = { 'tsv' },
  },
  pug = {
    install_info = {
      url = 'https://github.com/zealot128/tree-sitter-pug',
    },
  },
  puppet = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-puppet',
    },
  },
  purescript = {
    install_info = {
      url = 'https://github.com/postsolar/tree-sitter-purescript',
    },
  },
  pymanifest = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-pymanifest',
    },
    readme_name = 'PyPA manifest',
  },
  python = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-python',
    },
  },
  ql = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-ql',
    },
  },
  qmldir = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-qmldir',
    },
  },
  qmljs = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/yuja/tree-sitter-qmljs',
    },
    requires = { 'ecma' },
  },
  query = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-query',
    },
  },
  r = {
    install_info = {
      url = 'https://github.com/r-lib/tree-sitter-r',
    },
  },
  racket = {
    install_info = {
      url = 'https://github.com/6cdh/tree-sitter-racket',
    },
  },
  ralph = {
    install_info = {
      url = 'https://github.com/alephium/tree-sitter-ralph',
    },
  },
  rasi = {
    install_info = {
      url = 'https://github.com/Fymyte/tree-sitter-rasi',
    },
  },
  rbs = {
    install_info = {
      url = 'https://github.com/joker1007/tree-sitter-rbs',
    },
  },
  re2c = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-re2c',
    },
  },
  readline = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-readline',
    },
  },
  regex = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-regex',
    },
  },
  rego = {
    install_info = {
      url = 'https://github.com/FallenAngel97/tree-sitter-rego',
    },
  },
  requirements = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-requirements',
    },
    readme_name = 'pip requirements',
  },
  rescript = {
    install_info = {
      url = 'https://github.com/rescript-lang/tree-sitter-rescript',
    },
  },
  rnoweb = {
    install_info = {
      url = 'https://github.com/bamonroe/tree-sitter-rnoweb',
    },
  },
  robot = {
    install_info = {
      url = 'https://github.com/Hubro/tree-sitter-robot',
    },
  },
  robots = {
    install_info = {
      url = 'https://github.com/opa-oz/tree-sitter-robots-txt',
    },
  },
  roc = {
    install_info = {
      url = 'https://github.com/faldor20/tree-sitter-roc',
    },
  },
  ron = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-ron',
    },
  },
  rst = {
    install_info = {
      url = 'https://github.com/stsewd/tree-sitter-rst',
    },
  },
  ruby = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-ruby',
    },
  },
  rust = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-rust',
    },
  },
  scala = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-scala',
    },
  },
  scfg = {
    install_info = {
      generate = true,
      url = 'https://github.com/rockorager/tree-sitter-scfg',
    },
  },
  scheme = {
    install_info = {
      url = 'https://github.com/6cdh/tree-sitter-scheme',
    },
  },
  scss = {
    install_info = {
      url = 'https://github.com/serenadeai/tree-sitter-scss',
    },
    requires = { 'css' },
  },
  slang = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-slang',
    },
  },
  slint = {
    install_info = {
      url = 'https://github.com/slint-ui/tree-sitter-slint',
    },
  },
  smali = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-smali',
    },
  },
  smithy = {
    install_info = {
      url = 'https://github.com/indoorvivants/tree-sitter-smithy',
    },
  },
  snakemake = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/osthomas/tree-sitter-snakemake',
    },
  },
  solidity = {
    install_info = {
      url = 'https://github.com/JoranHonig/tree-sitter-solidity',
    },
  },
  soql = {
    install_info = {
      location = 'soql',
      url = 'https://github.com/aheber/tree-sitter-sfapex',
    },
  },
  sosl = {
    install_info = {
      location = 'sosl',
      url = 'https://github.com/aheber/tree-sitter-sfapex',
    },
  },
  sourcepawn = {
    install_info = {
      url = 'https://github.com/nilshelmig/tree-sitter-sourcepawn',
    },
  },
  sparql = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/GordianDziwis/tree-sitter-sparql',
    },
  },
  sql = {
    install_info = {
      branch = 'gh-pages',
      generate_from_json = true,
      url = 'https://github.com/derekstride/tree-sitter-sql',
    },
  },
  squirrel = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-squirrel',
    },
  },
  ssh_config = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-ssh-config',
    },
  },
  starlark = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-starlark',
    },
  },
  strace = {
    install_info = {
      url = 'https://github.com/sigmaSd/tree-sitter-strace',
    },
  },
  styled = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/mskelton/tree-sitter-styled',
    },
  },
  supercollider = {
    install_info = {
      url = 'https://github.com/madskjeldgaard/tree-sitter-supercollider',
    },
  },
  surface = {
    install_info = {
      url = 'https://github.com/connorlay/tree-sitter-surface',
    },
  },
  svelte = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-svelte',
    },
    requires = { 'html_tags' },
  },
  swift = {
    install_info = {
      generate = true,
      url = 'https://github.com/alex-pinkus/tree-sitter-swift',
    },
  },
  sxhkdrc = {
    install_info = {
      url = 'https://github.com/RaafatTurki/tree-sitter-sxhkdrc',
    },
  },
  systemtap = {
    install_info = {
      url = 'https://github.com/ok-ryoko/tree-sitter-systemtap',
    },
  },
  systemverilog = {
    install_info = {
      url = 'https://github.com/zhangwwpeng/tree-sitter-systemverilog',
    },
  },
  t32 = {
    install_info = {
      url = 'https://gitlab.com/xasc/tree-sitter-t32',
    },
  },
  tablegen = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-tablegen',
    },
  },
  tact = {
    install_info = {
      url = 'https://github.com/tact-lang/tree-sitter-tact',
    },
  },
  tcl = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-tcl',
    },
  },
  teal = {
    install_info = {
      generate = true,
      url = 'https://github.com/euclidianAce/tree-sitter-teal',
    },
  },
  templ = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/vrischmann/tree-sitter-templ',
    },
  },
  terraform = {
    install_info = {
      location = 'dialects/terraform',
      url = 'https://github.com/MichaHoffmann/tree-sitter-hcl',
    },
    requires = { 'hcl' },
  },
  textproto = {
    install_info = {
      url = 'https://github.com/PorterAtGoogle/tree-sitter-textproto',
    },
  },
  thrift = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-thrift',
    },
  },
  tiger = {
    install_info = {
      url = 'https://github.com/ambroisie/tree-sitter-tiger',
    },
  },
  tlaplus = {
    install_info = {
      url = 'https://github.com/tlaplus-community/tree-sitter-tlaplus',
    },
  },
  tmux = {
    install_info = {
      url = 'https://github.com/Freed-Wu/tree-sitter-tmux',
    },
  },
  todotxt = {
    install_info = {
      url = 'https://github.com/arnarg/tree-sitter-todotxt',
    },
  },
  toml = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-toml',
    },
  },
  tsv = {
    install_info = {
      location = 'tsv',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-csv',
    },
  },
  tsx = {
    install_info = {
      generate_from_json = true,
      location = 'tsx',
      url = 'https://github.com/tree-sitter/tree-sitter-typescript',
    },
    requires = { 'ecma', 'jsx', 'typescript' },
  },
  turtle = {
    install_info = {
      url = 'https://github.com/GordianDziwis/tree-sitter-turtle',
    },
  },
  twig = {
    install_info = {
      url = 'https://github.com/gbprod/tree-sitter-twig',
    },
  },
  typescript = {
    install_info = {
      generate_from_json = true,
      location = 'typescript',
      url = 'https://github.com/tree-sitter/tree-sitter-typescript',
    },
    requires = { 'ecma' },
  },
  typespec = {
    install_info = {
      url = 'https://github.com/happenslol/tree-sitter-typespec',
    },
  },
  typoscript = {
    install_info = {
      url = 'https://github.com/Teddytrombone/tree-sitter-typoscript',
    },
  },
  typst = {
    install_info = {
      url = 'https://github.com/uben0/tree-sitter-typst',
    },
  },
  udev = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-udev',
    },
  },
  ungrammar = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-ungrammar',
    },
  },
  unison = {
    install_info = {
      generate = true,
      url = 'https://github.com/kylegoetz/tree-sitter-unison',
    },
  },
  usd = {
    install_info = {
      url = 'https://github.com/ColinKennedy/tree-sitter-usd',
    },
  },
  uxntal = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-uxntal',
    },
  },
  v = {
    install_info = {
      location = 'tree_sitter_v',
      url = 'https://github.com/vlang/v-analyzer',
    },
  },
  vala = {
    install_info = {
      url = 'https://github.com/vala-lang/tree-sitter-vala',
    },
  },
  vento = {
    install_info = {
      url = 'https://github.com/ventojs/tree-sitter-vento',
    },
  },
  verilog = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-verilog',
    },
  },
  vhdl = {
    install_info = {
      url = 'https://github.com/jpt13653903/tree-sitter-vhdl',
    },
  },
  vhs = {
    install_info = {
      url = 'https://github.com/charmbracelet/tree-sitter-vhs',
    },
  },
  vim = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-vim',
    },
  },
  vimdoc = {
    install_info = {
      url = 'https://github.com/neovim/tree-sitter-vimdoc',
    },
  },
  vrl = {
    install_info = {
      url = 'https://github.com/belltoy/tree-sitter-vrl',
    },
  },
  vue = {
    install_info = {
      branch = 'main',
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-vue',
    },
    requires = { 'html_tags' },
  },
  wgsl = {
    install_info = {
      url = 'https://github.com/szebniok/tree-sitter-wgsl',
    },
  },
  wgsl_bevy = {
    install_info = {
      generate_from_json = true,
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-wgsl-bevy',
    },
  },
  wing = {
    install_info = {
      url = 'https://github.com/winglang/tree-sitter-wing',
    },
  },
  wit = {
    install_info = {
      url = 'https://github.com/liamwh/tree-sitter-wit',
    },
  },
  xcompose = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-xcompose',
    },
  },
  xml = {
    install_info = {
      location = 'xml',
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-xml',
    },
    requires = { 'dtd' },
  },
  yaml = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-yaml',
    },
  },
  yang = {
    install_info = {
      url = 'https://github.com/Hubro/tree-sitter-yang',
    },
  },
  yuck = {
    install_info = {
      url = 'https://github.com/tree-sitter-grammars/tree-sitter-yuck',
    },
  },
  zathurarc = {
    install_info = {
      url = 'https://github.com/Freed-Wu/tree-sitter-zathurarc',
    },
  },
  zig = {
    install_info = {
      url = 'https://github.com/maxxnino/tree-sitter-zig',
    },
  },
}
