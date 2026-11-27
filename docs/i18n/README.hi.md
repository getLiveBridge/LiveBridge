<p align="center"><a href="../../README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <b>हिन्दी</b> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ru.md">Русский</a> · <a href="README.uk.md">Українська</a></p>

<p align="center"><img src="../../site/assets/icon.png" alt="LiveBridge ऐप आइकन" width="144"></p>

<h1 align="center">LiveBridge</h1>

<p align="center"><strong>खुले Claude Code session से voice में बात करें।</strong></p>

<p align="center">उनके लिए जो Apple Silicon Mac पर Claude Code इस्तेमाल करते हैं और जिनके ChatGPT plan के Codex में voice शामिल है।</p>

<p align="center">
  <a href="https://github.com/getLiveBridge/LiveBridge/actions/workflows/ci.yml"><img src="https://github.com/getLiveBridge/LiveBridge/actions/workflows/ci.yml/badge.svg?branch=main" alt="CI"></a>
  <a href="https://scorecard.dev/viewer/?uri=github.com/getLiveBridge/LiveBridge"><img src="https://api.scorecard.dev/projects/github.com/getLiveBridge/LiveBridge/badge" alt="OpenSSF Scorecard"></a>
  <a href="https://www.bestpractices.dev/projects/16502"><img src="https://www.bestpractices.dev/projects/16502/badge" alt="OpenSSF Best Practices"></a>
  <img src="https://img.shields.io/badge/platform-macOS%2014%2B%20%C2%B7%20Apple%20Silicon-lightgrey.svg" alt="प्लेटफ़ॉर्म: Apple Silicon पर macOS 14+">
</p>

<p align="center">
  <a href="https://getlivebridge.com">getlivebridge.com</a> ·
  <a href="#त्वरित-शुरुआत">त्वरित शुरुआत</a> ·
  <a href="#इंस्टॉल-करना">इंस्टॉल</a> ·
  <a href="#उपयोग">उपयोग</a> ·
  <a href="#बिलिंग-का-ध्यान-रखने-वाला-डिज़ाइन">बिलिंग</a> ·
  <a href="#गोपनीयता">गोपनीयता</a> ·
  <a href="#ज्ञात-सीमाएँ">सीमाएँ</a> ·
  <a href="#रोडमैप-और-सहयोग-चाहिए">सहयोग चाहिए</a> ·
  <a href="#योगदान">योगदान</a>
</p>

LiveBridge एक macOS menu bar app है, जो आपके ChatGPT login पर `codex app-server` के ज़रिए GPT-Live
voice line तैयार रखता है (API key की ज़रूरत नहीं)। Voice फ्रंट डेस्क की तरह काम करता है: वह बातचीत
करता है, पूछता है कि आपका मतलब क्या है, और असली काम एक छोटे Claude Code mod, `livebridge`, के ज़रिए
आपके Claude Code session को सौंप देता है। Claude अपने model, tools और permission mode से काम करता
है, और voice आपको नतीजा बताता है। Claude के काम करते समय line खुली रखने की ज़रूरत नहीं: उसका जवाब
बंद line को फिर से खोलता है और voice को बोलने के लिए दिया जाता है। Voice यह भी जानता रहता है कि आप
session में क्या टाइप करते हैं और Claude क्या जवाब देता है, इसलिए आप बोलने और टाइप करने के बीच आ-जा
सकते हैं।

*मूल पाठ अंग्रेज़ी में है ([README.md](../../README.md)); यह अनुवाद पीछे रह सकता है।*

**बातचीत, डिक्टेशन नहीं।** GPT-Live बोलते हुए भी सुनता है: बीच में बोलें तो वह रुककर आपकी बात सुनता है; ज़ोर से सोचें तो वह छोटा-सा "हम्म" बोल सकता है। **बातचीत शांत होने पर line बंद हो जाती है:** OpenAI voice का दाम मिनट के हिसाब से लगाता है, इसलिए [सेटिंग्स](guide.hi.md#सेटिंग्स) में आपके तय किए हुए मौन (default 20 सेकंड) के बाद line बंद हो जाती है, और आपके बोलते ही फिर खुलती है, बातचीत वहीं से आगे बढ़ती है जहाँ छूटी थी। बंद होने से पहले का मौन billed होता है, और handoff के बाद Claude के जवाब का 2 मिनट तक का इंतज़ार भी; **Mute** line बंद नहीं करता, इसलिए उससे कोई मिनट नहीं बचते ([बिलिंग](#बिलिंग-का-ध्यान-रखने-वाला-डिज़ाइन))।

<p align="center"><img src="../assets/readme-demo.gif" alt="LiveBridge के ज़रिए Claude Code session से बात करना" width="100%"></p>

<p align="center">GIF में आवाज़ नहीं है: <a href="https://getlivebridge.com/assets/livebridge-demo.mp4">आवाज़ के साथ 64 सेकंड का demo</a> getlivebridge.com पर देखें।</p>

**डिज़ाइन से ही लोकल।** कोई telemetry नहीं और अपना कोई server नहीं: LiveBridge आपके Mac पर आपके अपने
codex और आपके अपने Claude Code के बीच एक bridge है। App और mod सिर्फ़ एक Unix socket पर बात करते
हैं, जिसे केवल आपका user खोल सकता है, और app किसी network port पर listen नहीं करता। जो traffic ये
दोनों tools पहले से भेजते हैं (voice line का traffic आपके codex के ज़रिए OpenAI को, सिर्फ़ तब जब line खुली हो, साथ में जुड़े session में आपका टाइप किया text, और Claude का काम आपके Claude Code session के ज़रिए Anthropic को), उसके अलावा app का
अपना traffic सिर्फ़ ये है: menu खोलने पर थोड़ी देर चलने वाला एक codex OpenAI से आपके Codex usage के आँकड़े
माँगता है, call बंद हो तब भी; और [updates](guide.hi.md#अपडेट-करना) का traffic: GitHub से नए release की अपने-आप होने वाली जाँच
(दिन में एक बार, और हर launch पर जब तक उसके बताए release को install न किया गया हो), जिसे आप बंद कर
सकते हैं; **Check for update** दबाने पर वही जाँच; नए release की सूचना देने पर `gh auth status`; और
**Install** click करने पर download, उसकी जाँच और mod का update। [गोपनीयता](privacy.hi.md) में ठीक-ठीक
लिखा है कि OpenAI तक क्या पहुँचता है, और GitHub को भेजे जाने वाले app के requests के नाम भी वहीं
हैं; [SECURITY.md](../../SECURITY.md) बताता है कि यह किस चीज़ से बचाता है और किस चीज़ से नहीं।

> **स्थिति:** 0.x, एक maintainer। **अनौपचारिक:** Anthropic या OpenAI से संबद्ध नहीं, न उनके द्वारा
> समर्थित या endorsed। LiveBridge आपके ChatGPT login पर codex का experimental realtime API इस्तेमाल
> करता है, जिसे OpenAI third-party apps के रास्ते के रूप में document नहीं करता, और codex का कोई
> release इसे तोड़ सकता है। इसे अपने जोखिम पर इस्तेमाल करें।
>
> **ज़रूरी:** Apple Silicon पर macOS 14 या नया, Claude Code 2.1.301 या नया, और
> [codex](https://github.com/openai/codex), जिसमें `codex login` से ऐसे ChatGPT plan पर sign in किया
> गया हो जिसके Codex में voice शामिल है; voice के मिनट उसी plan से कटते हैं। app को खुद build करने के
> लिए Swift 6.0 या नए वाला Xcode भी। विवरण [आवश्यकताएँ](#आवश्यकताएँ) में हैं।

## त्वरित शुरुआत

```sh
# 1. The app, from LiveBridge's own Homebrew tap
brew install --cask getlivebridge/tap/livebridge

# 2. The mod, from this repository's marketplace
claude plugin marketplace add getLiveBridge/LiveBridge
claude plugin install livebridge@livebridge
```

3. Applications से LiveBridge खोलें। पहली बार macOS पूछता है कि internet से download किया गया app
   खोलें या नहीं; **Open** पर click करें। LiveBridge menu bar में चलता है।
4. जिस Claude Code session से बात करनी है, उसमें `/live` टाइप करें। वह "Joined LiveBridge." जवाब
   देता है, और prompt के ऊपर एक band दिखता है: **Voice off**, वह session जिससे call बात करती है, और
   **Start**।
5. **Start** दबाएँ। पहली बार macOS microphone की अनुमति माँगता है: अनुमति दें। वह यह भी पूछ सकता है
   कि क्या LiveBridge आपके local network पर devices ढूँढ सकता है; voice line को यह भी चाहिए। अब band
   **Listening** दिखाता है: आपके Mac पर एक voice detector आपके बोलने का इंतज़ार करता है, और जब तक आप
   बोलते नहीं, कोई audio आपके Mac से बाहर नहीं जाता। मौजूदा mod के साथ, जब voice के पास session का
   कोई हिस्सा न हो, जैसे पहली call पर, तो Start उसी समय session से एक छोटा सारांश माँग लेता है, जब
   तक **Pause sync** उसे रोक न ले: Claude उसे आपके Claude Code के ज़रिए, आपके Claude usage से लिखता
   है, और वह OpenAI तक सिर्फ़ line के साथ जाता है ([कब](guide.hi.md#बैंड-और-मेन्यू))।
6. पूछें "यह session किस पर काम कर रहा है?"। band **Connecting** और फिर **Live** दिखाता है, और voice
   जवाब देता है, session की बातचीत से या सवाल Claude को सौंपकर। कोई बदलाव माँगें, तो voice उसे Claude
   को सौंपता है और Claude का काम पूरा होने पर नतीजा बताता है। बातचीत शांत होने पर line बंद हो जाती है
   और band फिर **Listening** दिखाता है ([कब](#बिलिंग-का-ध्यान-रखने-वाला-डिज़ाइन))।

Homebrew नहीं है? हर [release](https://github.com/getLiveBridge/LiveBridge/releases/latest) में app
एक disk image के रूप में मिलता है, जिसे GitHub Actions ने build और attest किया है
([डिस्क इमेज से](#डिस्क-इमेज-से)), या उसे खुद build करें ([सोर्स से](#सोर्स-से))। mod हर तरीके में
एक ही तरह install होता है।

अगर पहले से खुले session में `/live` नहीं मिलता, तो session दोबारा खोलें ([क्यों](#ज्ञात-सीमाएँ))।
disk image, सोर्स से build और अनुमतियाँ [इंस्टॉल करना](#इंस्टॉल-करना) में हैं; बाकी
[अपडेट करना](guide.hi.md#अपडेट-करना), [अनइंस्टॉल करना](guide.hi.md#अनइंस्टॉल-करना) और [उपयोग](#उपयोग) में।

## आवश्यकताएँ

- Apple Silicon पर macOS 14 या उसके बाद का संस्करण।
- Claude Code 2.1.301 या उसके बाद का संस्करण।
- [Codex CLI](https://github.com/openai/codex) (`codex`, 0.172.0 के साथ टेस्ट किया गया), जो
  Homebrew (`brew install --cask codex`) या npm (`npm install -g @openai/codex`) से install हो,
  Terminal window में आपके shell द्वारा सेट किए गए `PATH` पर हो, और `codex login` से ऐसे ChatGPT plan
  पर sign in हो जिसके Codex में voice शामिल है (Plus, Pro, Business, Enterprise या Education,
  [OpenAI की Codex pricing](https://learn.chatgpt.com/docs/pricing) के अनुसार)। जिस codex की `codex features list` LiveBridge पढ़
  नहीं पाता, उसे वह अस्वीकार कर देता है, इसलिए कोई दूसरा संस्करण तब तक शुरू नहीं हो सकता जब तक
  LiveBridge अपडेट न हो।
- App build करने के लिए: Swift 6.0 या उसके बाद के toolchain वाला Xcode। टेस्ट किए गए संस्करण
  [CONTRIBUTING.md](../../CONTRIBUTING.md#toolchain) में हैं। Build किया हुआ app macOS 14 या उसके बाद के संस्करण पर चलता है।

## इंस्टॉल करना

mod इस repository के marketplace से आता है ([त्वरित शुरुआत](#त्वरित-शुरुआत) के commands), जो नवीनतम
release के tag की ओर इशारा करता है, इसलिए आप जो mod install करते हैं वह उसी release का होता है। App
किसी भी तरीके से install करें, `/Applications` में जाता है: Homebrew से, disk image से, या source से
build करके। 0.4.2 के बाद के पहले release से, डिस्क इमेज, जिसे Homebrew भी install करता है,
LiveBridge की Developer ID से signed और Apple द्वारा notarized है; 0.4.2 और उससे पहले के releases ad
hoc signed थे और notarized नहीं हैं, और source से बना build न तो Developer ID से signed होता है और न
notarized।

### डिस्क इमेज से

1. नवीनतम release से
   [LiveBridge.dmg](https://github.com/getLiveBridge/LiveBridge/releases/latest/download/LiveBridge.dmg)
   डाउनलोड करें।
2. उसे [GitHub CLI](https://cli.github.com) से जाँचें, उसी folder में जहाँ आपने उसे सेव किया है:

   ```sh
   gh attestation verify LiveBridge.dmg --repo getLiveBridge/LiveBridge \
     --signer-workflow getLiveBridge/LiveBridge/.github/workflows/release.yml \
     --source-ref refs/tags/vX.Y.Z --deny-self-hosted-runners
   ```

   जहाँ `vX.Y.Z` release का tag है, जैसा उसके page पर लिखा है। यह जाँच सिर्फ़ ऐसी image के लिए पास
   होती है जिसे इस repository के [release workflow](../../.github/workflows/release.yml) ने उसी tag से,
   GitHub के अपने (GitHub-hosted) runner पर, build किया हो और जो तब से बदली न हो। 0.4.2 के बाद के release पर Developer ID
   signature, जिसे macOS खुद जाँचता है, बताता है कि image पर किसने sign किया, और यह जाँच बताती है कि वह
   किससे build हुई थी; 0.4.2 और उससे पहले के releases पर, जिनका ad hoc signature किसी का नाम नहीं बताता,
   यह जाँच image के origin का इकलौता प्रमाण है। यह इस बात का प्रमाण नहीं है कि किसी ने code की समीक्षा की है।
3. उसे खोलें और LiveBridge को Applications में drag करें।
4. पहली बार launch करने पर, 0.4.2 के बाद के release पर macOS पूछता है कि internet से download किया गया
   app खोलना है या नहीं; **Open** पर click करें। 0.4.2 और उससे पहले के releases तब तक blocked रहते हैं जब तक
   आप उन्हें System Settings > Privacy & Security > **Open Anyway** में अनुमति नहीं देते।

### Homebrew से

```sh
brew install --cask getlivebridge/tap/livebridge
```

यह वही डिस्क इमेज [LiveBridge के अपने tap](https://github.com/getLiveBridge/homebrew-tap) से इंस्टॉल करता है, जो Homebrew का आधिकारिक cask नहीं
है। Homebrew पहले इस tap पर भरोसा करने को कह सकता है, और macOS पहली बार खोलने पर ऊपर बताए अनुसार पूछता
है। इसके बाद app खुद अपडेट होता है ([अपडेट करना](guide.hi.md#अपडेट-करना))।

### सोर्स से

`scripts/build-app.sh --release` app को build करता है, उसे `/Applications` में install करता है (आपके
account को वहाँ लिखने का अधिकार होना चाहिए, जैसा administrator के पास होता है) और खोल देता है।
दोबारा build करने के लिए इसे फिर से चलाएँ। Build ad hoc signed होता है, इसलिए हर नए build के बाद
macOS microphone के लिए दोबारा पूछता है। अनुमति बनाए रखने के लिए
`scripts/build-app.sh --make-signing-identity` एक बार चलाएँ: यह पहले पूछता है, फिर आपके login
keychain में एक self-signed code-signing certificate बनाता है, और बाद के release builds उसी से sign
होते हैं।

marketplace mod को पिछले release के tag पर pin करता है, इसलिए default branch से बना app उसी release
के mod के साथ चलता है। दोनों को मिलाने के लिए release का tag build करें (`git checkout vX.Y.Z`), या
`claude --plugin-dir plugin` से working tree का mod load करें।

source से बना build updates की जाँच अपने-आप तभी करता है जब आप Settings में इसे चालू करें। Update
install करने पर वह release की image से बदल जाता है, जो LiveBridge की Developer ID से signed है,
आपके self-signed certificate से नहीं, इसलिए macOS microphone के लिए एक बार फिर पूछता है; **Install** यह
बताता है और पहले पूछता है।

### अनुमतियाँ

पहली बार Start करने पर macOS से microphone माँगा जाता है। अगर मना कर दिया गया, तो call एक वाक्य के
साथ रुक जाती है और menu bar menu का **Open Microphone Settings** Privacy & Security > Microphone खोल
देता है, जहाँ आप LiveBridge को अनुमति देते हैं। macOS किसी ad hoc release से पहले update के बाद, और source से बने हर ad hoc signed rebuild के बाद, पहले
Start पर फिर पूछता है (ऊपर देखें)। macOS यह भी पूछ सकता है कि क्या LiveBridge आपके local
network पर devices खोज सकता है। voice line को यह दूसरी अनुमति भी चाहिए; इसके बिना call एक वाक्य के
साथ रुक जाती है, जो बताता है कि इसे कहाँ allow करना है।

### अपडेट और अनइंस्टॉल

जब आप **Install** पर click करते हैं, LiveBridge खुद को और अपने mod को update करता है, अपने आप कभी
नहीं; वह पहले क्या जाँचता है और हाथ से update कैसे करें, यह [अपडेट करना](guide.hi.md#अपडेट-करना) में
है। [अनइंस्टॉल करना](guide.hi.md#अनइंस्टॉल-करना) menu के **Uninstall LiveBridge…**, Homebrew, repository
के clone और हाथ से किए जाने वाले steps को बताता है।

## ज्ञात सीमाएँ

पूरी सूची, हर मापे गए बिंदु के पीछे के record के साथ, [known-limitations.hi.md](known-limitations.hi.md)
में है। संक्षेप में:

- **voice एक language model है, और वह हमेशा वही नहीं करता जो उसे कहा गया है।** कभी-कभी वह कहता है
  कि देख रहा है पर request handoff नहीं करता, तो Claude तक कुछ नहीं पहुँचता: अगर queue में गई request
  की छोटी आवाज़ उसके बाद नहीं आती, तो request दोबारा कहें। जब Claude का जवाब line फिर खोलता है, तब वह
  चुप रह सकता है; तब जवाब chime बजाकर इंतज़ार करता है। हो सकता है वह Claude के इंतज़ार वाले सवाल या
  permission prompt का ज़िक्र न करे, इसलिए Mac से दूर हों तो उस पर भरोसा न करें। prompt फिर भी Claude
  Code में इंतज़ार करता है, और LiveBridge उसका जवाब कभी नहीं देता।
- **आपके ChatGPT plan की usage limit पर** voice तब तक रुक जाता है जब तक limit reset न हो। Claude Code
  काम करता रहता है, और उसके जवाब इंतज़ार करते हैं।
- **जहाँ कोई organization Claude Code manage करता है**, वहाँ LiveBridge में कुछ नहीं बताता कि कोई
  permission prompt इंतज़ार कर रहा है, और कुछ managed settings mod को load होने नहीं देतीं।
- **`/live`** के लिए session दोबारा खोलना पड़ सकता है, अगर वह mod load होने से पहले खुला था।
- **Connect over TCP** TCP को प्राथमिकता देता है पर उसे ज़बरदस्ती नहीं करता, और call के दौरान कुछ
  नहीं दिखाता कि line ने कौन-सा transport लिया; debug mode उसे दर्ज करता है (`onTcp`)।
- voice ने इंतज़ार कर रहा नतीजा कह दिया या नहीं, यह उसके शब्दों से आँका जाता है, सिर्फ़ अंग्रेज़ी और
  रूसी में। पूरी सूची में ये भी हैं: जो prompts टाइप नहीं किए गए, summary model के बिना providers, और
  पुराने mod पर चल रहे sessions।

## उपयोग

जिस Claude Code session से बात करनी है, उसमें `/live` उसे LiveBridge से जोड़ता है और `/live off`
अलग करता है। prompt के ऊपर वाले band में या menu bar menu में **Start** call शुरू करता है; **Mute**
call चलते हुए microphone छोड़ देता है, **Stop** call खत्म करता है, और **Talk here** call को उस session
पर ले जाता है जिसके band में आप उसे दबाते हैं। menu bar menu जुड़े हुए sessions, target की voice के
साथ बातचीत, आपके मिनट और usage, और **Settings…** दिखाता है: voice, उसके लिए आपका अपना prompt, मौन
कितनी देर line खुली रखता है, और आपके sessions voice तक कैसे पहुँचते हैं।

[guide.hi.md](guide.hi.md) हर command, band, menu और हर setting बताता है, और यह भी कि voice आपकी
requests और Claude के जवाबों और सवालों के साथ क्या करता है।

## बिलिंग का ध्यान रखने वाला डिज़ाइन

realtime voice line खुली रहने तक पैसे लगते हैं, इसलिए LiveBridge उसे तभी खोलता है जब कोई बोल रहा हो,
जब तक आपकी request पर Claude का जवाब अभी आ सकता हो (हर handoff के बाद 2 मिनट तक), या आपको Claude का
जवाब, आपसे उसका सवाल या यह बताने के लिए कि वह आपकी मंज़ूरी का इंतज़ार कर रहा है। line बंद रहने पर
microphone सिर्फ़ आपके Mac पर एक voice detector को feed करता है, और कोई audio नहीं भेजा जाता। menu
दिखाता है कि line कितने मिनट खुली रही और आपके Codex और Claude usage का कितना हिस्सा इस्तेमाल हुआ;
आपके plan का अपना usage page अंतिम स्रोत है। हर नियम
[guide.hi.md](guide.hi.md#बिलिंग-का-ध्यान-रखने-वाला-डिज़ाइन) में है।

## गोपनीयता

संक्षेप में: कोई telemetry नहीं, अपना कोई server नहीं और कोई network port नहीं, और आपकी आवाज़, जुड़े
हुए session में आपका टाइप किया हुआ, और Claude के जवाब और summaries आपके codex के ज़रिए OpenAI तक तभी
जाते हैं जब कोई line खुली हो। [privacy.hi.md](privacy.hi.md) OpenAI तक पहुँचने वाली हर चीज़ और उसकी
सीमाएँ, credential redactor क्या ढकता है, GitHub को हर request, और app आपके Mac पर क्या रखता है, यह
सब बताता है।

[SECURITY.md](../../SECURITY.md) में threat model है: संक्षेप में, जो कुछ भी आपका microphone सुन सकता है
वह एक ऐसा अनुरोध बन सकता है जिसे Claude session के अपने permission mode के तहत चलाता है।

## यह कैसे काम करता है

[docs/architecture/overview.md](../../docs/architecture/overview.md) components, mod और app के बीच की wire,
और message flows का वर्णन करता है; [ADR 0001](../../docs/adr/0001-platform-findings.md) उन platform तथ्यों को
दर्ज करता है जिन पर design टिका है।

## रोडमैप और सहयोग चाहिए

LiveBridge आज एक Mac app, एक worker (Claude Code) और एक voice provider (ChatGPT login पर codex) है।
ये तीनों संकरे जोड़ों (seams) पर मिलते हैं, और नीचे की हर दिशा contributors के लिए खुली है। उनके issues पर
[help wanted](https://github.com/getLiveBridge/LiveBridge/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
label लगा होता है; [CONTRIBUTING.md](../../CONTRIBUTING.md#where-to-start) बताता है कि पहले कौन-सी फ़ाइलें पढ़ें।

- **Windows और Linux।** Menu bar app, उसका audio page और socket server macOS से बँधे हैं; mod और app के
  बीच की wire, और खुद mod, portable हैं। पोर्ट की शुरुआत नए platform के ऐसे app से होती है जो वही wire बोलता हो।
- **Worker के रूप में दूसरे agents**, जैसे Codex CLI, Hermes Agent या Gemini CLI: हर एक को अपना adapter
  चाहिए जो Claude Code mod जैसी ही wire बोले।
- **दूसरे voice providers**, जैसे आपकी अपनी API key के साथ OpenAI Realtime API या Google का Gemini Live API:
  हर एक app के realtime protocol का एक और implementation होगा।

## योगदान

योगदान का स्वागत है। किसी fix से बड़ी चीज़ के लिए पहले एक issue खोलें, ताकि काम शुरू होने से पहले उसका
स्वरूप तय हो सके। शुरू करने की अच्छी जगहें हैं
[help wanted](https://github.com/getLiveBridge/LiveBridge/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
issues, [ज्ञात सीमाएँ](#ज्ञात-सीमाएँ) और [ऊपर](#रोडमैप-और-सहयोग-चाहिए) बताई गई दिशाएँ।

आप coding assistants इस्तेमाल कर सकते हैं: pull request में बताएँ कि कौन-से हिस्से किसी tool ने
generate किए, `scripts/check.sh` चलाएँ, और बदली गई हर line समझाने के लिए तैयार रहें
([AI-assisted contributions](../../CONTRIBUTING.md#ai-assisted-contributions))।

- [CONTRIBUTING.md](../../CONTRIBUTING.md): layout, toolchain, checks (`scripts/check.sh`) और conventions।
- [Issue forms](https://github.com/getLiveBridge/LiveBridge/issues/new/choose): bug की रिपोर्ट करें या कोई feature माँगें।
- [CODE_OF_CONDUCT.md](../../CODE_OF_CONDUCT.md): यहाँ हम एक-दूसरे के साथ कैसे पेश आते हैं।
- [SECURITY.md](../../SECURITY.md): vulnerability की रिपोर्ट निजी तौर पर करें, public issue में नहीं।
- [CHANGELOG.md](../../CHANGELOG.md): हर release में क्या बदला।

## श्रेय

mod और app के बीच के wire protocol की प्रेरणा
[claude-code-voice-mod](https://github.com/ldk00315-jpg/claude-code-voice-mod) से मिली। उससे कोई code या text
कॉपी नहीं किया गया।

## लाइसेंस

[MIT](../../LICENSE)।
