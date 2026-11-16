$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object Text.UTF8Encoding($false)
$green = '#c4fa6a'
$font = 'Segoe UI,Arial,sans-serif'
$mono = 'Consolas,DejaVu Sans Mono,monospace'

function Write-Asset([string]$Name, [string]$Content) {
    [IO.File]::WriteAllText((Join-Path $root "assets/$Name"), $Content, $utf8)
}

function Get-Logo([string]$Slug) {
    $xml = [xml](Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $root "assets/icons/$Slug.svg"))
    $paths = foreach ($node in $xml.DocumentElement.ChildNodes) {
        if ($node.LocalName -eq 'path') { '<path d="' + $node.GetAttribute('d') + '"/>' }
    }
    if (-not $paths) { throw "Missing logo paths: $Slug" }
    return ($paths -join '')
}

$technologies = @(
    @{ slug='python'; file='python'; label='Python'; width=100 },
    @{ slug='fastapi'; file='fastapi'; label='FastAPI'; width=110 },
    @{ slug='django'; file='django'; label='Django'; width=108 },
    @{ slug='postgresql'; file='postgresql'; label='PostgreSQL'; width=146 },
    @{ slug='docker'; file='docker'; label='Docker'; width=106 },
    @{ slug='linux'; file='linux'; label='Linux'; width=94 },
    @{ slug='git'; file='git'; label='Git'; width=76 },
    @{ slug='html5'; file='html5'; label='HTML'; width=92 },
    @{ slug='css'; file='css3'; label='CSS'; width=84 },
    @{ slug='javascript'; file='javascript'; label='JavaScript'; width=132 }
)
$badges = @()
$x = 28
foreach ($technology in $technologies) {
    $width = $technology.width
    $label = $technology.label
    $logo = Get-Logo $technology.slug
    $badge = @"
<rect x=".5" y=".5" width="$($width - 1)" height="35" rx="7" fill="#152014" stroke="#34472b"/>
<g transform="translate(10 8) scale(.833333)" fill="$green">$logo</g>
<text x="39" y="23.5" font-family="$font" font-size="16" font-weight="500" fill="$green">$label</text>
"@
    Write-Asset "$($technology.file).svg" "<svg xmlns=`"http://www.w3.org/2000/svg`" width=`"$width`" height=`"36`" viewBox=`"0 0 $width 36`"><title>$label</title>$badge</svg>"
    $badges += "<g transform=`"translate($x 181)`">$badge</g>"
    $x += $width + 10
}

$torusXml = [xml](Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $root 'assets/torus.svg'))
$torusNode = $torusXml.DocumentElement.FirstChild
$torusNode.SetAttribute('stroke-width', '1.5')
$torusNode.SetAttribute('opacity', '.95')
$torus = $torusXml.DocumentElement.InnerXml
$header = @"
<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="260" viewBox="0 0 1200 260" role="img" aria-labelledby="title description">
<title id="title">Nikita Sychev — Python, Data, Automation</title>
<desc id="description">Веб-сервисы, API, боты и интеграции. Данные, нейросети и автоматизация. Интерфейсы с помощью AI. Python, FastAPI, Django, PostgreSQL, Docker, Linux, Git, HTML, CSS, JavaScript. Этот профиль — дублёр github.com/nikita-sychev182.</desc>
<defs>
<pattern id="grid" width="16" height="16" patternUnits="userSpaceOnUse"><circle cx="1" cy="1" r=".6" fill="#526d3a" opacity=".4"/></pattern>
<radialGradient id="glow"><stop stop-color="#90c246" stop-opacity=".09"/><stop offset="1" stop-color="#90c246" stop-opacity="0"/></radialGradient>
</defs>
<rect x=".5" y=".5" width="1199" height="259" rx="10" fill="#0d1410" stroke="#2e3e28"/>
<rect x="352" y="16" width="198" height="139" fill="url(#grid)"/>
<ellipse cx="450" cy="88" rx="125" ry="95" fill="url(#glow)"/>
<path d="M18 32V18H32M1168 18H1182V32M18 228V242H32M1168 242H1182V228" fill="none" stroke="#587440" stroke-width=".8"/>
<text x="28" y="30" font-family="$mono" font-size="13" letter-spacing="1.5" fill="#9eb885">@SYCHEVNICK94</text>
<g font-family="$font" font-size="67" font-weight="800" letter-spacing="-3">
<text x="25" y="88" fill="#eef6e8">NIKITA</text>
<text x="25" y="148" fill="$green">SYCHEV<tspan fill="#eef6e8">.</tspan></text>
</g>
<g transform="translate(450 91) scale(.34) translate(-935 -200)">$torus</g>
<path d="M569 28V148" stroke="#34472b"/>
<text x="598" y="36" font-family="$mono" font-size="16" letter-spacing="1.2" fill="$green">PYTHON / DATA / AUTOMATION</text>
<g font-family="$font" font-size="22" fill="#d5e2cd">
<text x="598" y="77">Веб-сервисы, API, боты и интеграции.</text>
<text x="598" y="109">Данные, нейросети и автоматизация.</text>
<text x="598" y="141">Интерфейсы с помощью AI.</text>
</g>
<path d="M28 165H1172M28 232H1172" stroke="#2e3e28"/>
$($badges -join "`n")
<text x="28" y="250" font-family="$mono" font-size="13" letter-spacing=".7" fill="#9eb885">ПЕРЕНОС С GITHUB.COM/NIKITA-SYCHEV182 · КОПИИ РЕПОЗИТОРИЕВ</text>
<circle cx="1028" cy="245.5" r="3" fill="$green"/>
<text x="1040" y="250" font-family="$mono" font-size="12" letter-spacing=".8" fill="$green">GITLAB PROFILE</text>
</svg>
"@
Write-Asset 'header.svg' $header

$contactIcons = @{
    telegram = '<path d="m3 10 18-7-5 18-6-7-7-4Zm7 4 11-11M10 14l-1 5 4-2"/>'
    email = '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 6 9 7 9-7"/>'
    github = '<path d="m9 7-5 5 5 5m6-10 5 5-5 5m-2-13-2 20"/>'
}
$contacts = @(
    @{ slug='telegram'; label='TELEGRAM'; width=144 },
    @{ slug='email'; label='EMAIL'; width=120 },
    @{ slug='github'; label='GITHUB / NIKITA-SYCHEV182'; width=286 }
)
foreach ($contact in $contacts) {
    $width = $contact.width
    $label = $contact.label
    $icon = $contactIcons[$contact.slug]
    Write-Asset "$($contact.slug).svg" @"
<svg xmlns="http://www.w3.org/2000/svg" width="$width" height="32" viewBox="0 0 $width 32"><title>$label</title>
<rect x=".5" y=".5" width="$($width - 1)" height="31" rx="6" fill="#152014" stroke="#4b6637"/>
<g transform="translate(10 7) scale(.75)" fill="none" stroke="$green" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">$icon</g>
<text x="37" y="20.5" font-family="$mono" font-size="12" font-weight="600" fill="$green">$label</text>
<path d="M$($width-19) 20l7-7m-6 0h6v6" fill="none" stroke="$green" stroke-width="1.2"/>
</svg>
"@
}
