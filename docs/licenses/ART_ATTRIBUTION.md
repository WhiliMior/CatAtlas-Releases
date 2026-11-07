# Cat Atlas 0.2 credits

## Original game art
Black-and-white cat with cobalt scarf and vermilion satchel, hand-painted object icon atlas, and rag paper texture: generated for Cat Atlas with OpenAI image generation during the approved art Lookbook work. Prompts are preserved in docs/art-lookbook-v02/PROMPTS.md. No SEASON character, screenshot or game texture is redistributed.

## Local geography
Made with Natural Earth. Public-domain geography, simplified for an interactive game globe. See data/WORLD_LICENSE.md. Names, subdivisions and disputed-boundary treatment follow the source snapshot and do not claim exhaustive or current legal administrative accuracy. Transit links are explicitly labelled game routes.

## Runtime travel photographs
No destination landscape, food or souvenir photograph is shipped in this package. The game uses Bing image search with Wikimedia Commons fallback, prefetching at departure and caching selected photos in the player's private save folder. Each record retains the creator, original file description URL, licence and licence URL. Attribution is visible in the journal when its photo is selected. Search relevance remains dependent on third-party metadata; players may remove a result or use personal images.

## Personal images
Imported images remain local. The game does not upload player images or journal notes.

## IP location
Initial region suggestion uses https://ipapi.co/json/ once during the start-location dialog. This request necessarily exposes the connection IP to that service; exact response/IP is not stored. The player can manually override the suggested province. Network failure leaves manual selection available.

## Runtime
Godot Engine, MIT licence and third-party notices are distributed in GODOT_LICENSES.txt. Chinese text uses system fonts; no proprietary font files are redistributed.

## 旅途奇物原画 V3（2026-10-12）

art/oddity_icons/ 的 31 件透明底奇物插画由 OpenAI 内置 image_gen 为 Cat Atlas 分件生成，每件独立维护，已替换运行时的旧 SVG 奇物图标。完整提示词、对象设定与生成记录位于 docs/art-lookbook-v02/oddities-v3-prompts.json。物件为受日常工艺启发的原创旅行收藏品；文化资料只作为设计参考，未复制或打包博物馆藏品照片。纸张、字体与其他素材署名沿用现有记录。

## Local flag graphics

Bundled flag SVGs are from Twemoji 17.0.3 (https://github.com/jdecked/twemoji), graphics licensed under CC BY 4.0. The original graphics licence is included in FLAG_LICENSE.txt. Local filenames map the source graphics to ISO flag codes; no proprietary emoji fonts are shipped.

## Production records

Current cat animation prompts: docs/CAT_ANIMATION_PROMPTS.txt. Mode button prompts: docs/MODE_PERCH_PROMPTS.txt. UI materials manifest: docs/art-lookbook-v02/production-assets.json. Each runtime frame and curio illustration remains a separate editable file.

Notebook cat stickers in art/cat_stickers/ were generated separately with the built-in OpenAI image generation tool for Cat Atlas. The approved dialog lookbook and original Cat Atlas character were used as references. Prompts and selected source records are in docs/art-dialogs/. Procedural dialog ornament and SVG action icons are original project UI work; text remains an editable localization layer.
