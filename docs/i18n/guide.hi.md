# LiveBridge का उपयोग

*अंग्रेज़ी पाठ ही मूल है ([guide.md](../guide.md)); यह अनुवाद पीछे रह सकता है।*

हर command, band, menu और हर setting; voice क्या करता है; line का bill कैसे बनता है; और update और
uninstall कैसे करें। [README](README.hi.md) में सारांश, आवश्यकताएँ और install के steps हैं,
[privacy.hi.md](privacy.hi.md) में यह कि आपके Mac से क्या बाहर जाता है, और
[known-limitations.hi.md](known-limitations.hi.md) में यह कि अभी क्या काम नहीं करता।

## उपयोग

### कमांड

जिस Claude Code session से बात करनी है, उसमें:

| Command | क्या करता है |
|---|---|
| `/live` | session के title के नाम से LiveBridge से जुड़ता है, और app चल नहीं रहा हो तो उसे खोलता है। जुड़े हुए session में band वापस लाता है और एक पंक्ति में जवाब देता है: call, target, न सुने गए नतीजे, आज के मिनट। |
| `/live off` | LiveBridge से अलग हो जाता है। |

Command `/live` है, `/voice` नहीं, क्योंकि `/voice` Claude Code का अपना voice mode है। call रुकी होने पर session में टाइप किया
हुआ voice से बाहर रखा जाए या नहीं, यह कोई command नहीं है: यह सभी sessions के लिए एक
setting है, जो LiveBridge की [सेटिंग्स](#सेटिंग्स) window में है।

### बैंड और मेन्यू

**Start** दबाएँ, prompt के ऊपर वाले band में या menu bar menu में, और बोलें।

- **band का Start** अपने session को target बनाता है और call शुरू करता है; जो line वह खोलता है उसे
  session की conversation मिलती है, और सारांश वह तब भी load करती है जब voice के पास session का कुछ
  हिस्सा न होता (नीचे **Load context** देखें), पर **Pause sync** चालू रहते या pause के बाद सिर्फ़ तब जब उसका सारांश अभी न हो
  ([विवरण](../../docs/architecture/overview.md#when-the-app-asks))। इस release के mod के साथ सारांश Start पर और
  call के दौरान target बदलने पर माँगा जाता है, और line जुड़ने से पहले उसका इंतज़ार करती है,
  ज़्यादा से ज़्यादा [इंतज़ार की सीमा](../../docs/architecture/overview.md#its-time) तक: इस बीच आप जो कहते हैं वह Mac पर रखा जाता है और line खुलने पर voice तक पहुँचता
  है। इंतज़ार के दौरान Stop या target बदलना रखी हुई बात को हटा देता है, और **Connect over TCP**
  बदलने के बाद का reconnect भी, जो दोबारा खुलने वाली line के लिए ज़्यादा से ज़्यादा
  आख़िरी 2 सेकंड रखता है। जब call किसी दूसरे session से बात कर रही हो,
  तब band **Talk here** दिखाता है। अगर जुड़े हुए session में band न दिखे, तो `/live` उसे वापस ले
  आता है।
- **Menu bar menu** में call, जुड़े हुए sessions (किसी पर click करके उसे target बनाएँ),
  **Load context**, target की **Conversation** (जैसी LiveBridge उसे रखता है, voice के Claude को सौंपे
  हर अनुरोध के लिए एक **Task** पंक्ति और जहाँ सारांश load हुआ वहाँ एक **Loaded context** पंक्ति के साथ), उपयोग की सीमाएँ, मिनट,
  **Quick Settings** (**Connect over TCP**, **Play sounds for requests and answers**, **Notify when a result is waiting**, **Pause sync while the call is stopped** और **Load a session's context on its first call** के checkmark items),
  **Settings…**, **Feedback & Support** (**Report a Bug…** repository का bug report form खोलता है,
  **LiveBridge Website** getlivebridge.com खोलता है, **Star LiveBridge on GitHub** repository का page
  खोलता है, फिर **Debug Mode** और **Show Debug Files**, [debug mode](#सेटिंग्स) का switch और
  folder, और **Uninstall LiveBridge…** ([अनइंस्टॉल करना](#अनइंस्टॉल-करना))) और **Quit LiveBridge** होते हैं। जब menu में सिर्फ़ call दिखती है, तब भी Quick Settings
  वहाँ होता है। call के दौरान **Conversation** आपके और voice के शब्द
  वैसे-वैसे दिखाता है जैसे-जैसे codex उन्हें transcribe करता है, इसलिए आपके शब्द बोलने के थोड़ी देर बाद, और
  voice के शब्द सुनाई देने से थोड़ा पहले दिख सकते हैं। हर बात पूरी होने पर उसका अंतिम पाठ इन शब्दों की जगह
  ले लेता है। सिर्फ़ अंतिम पाठ रखा जाता है: line बंद होने तक जिन शब्दों को अंतिम पाठ नहीं मिला, वे चले जाते हैं।
- **Mute** (**Stop** के बगल में, band में और menu के call card में; muted होने पर **Unmute**) call
  चलते रहने के दौरान आपका microphone छोड़ देता है: Claude का जवाब फिर भी line खोलता है और voice को
  बोलने के लिए दिया जाता है। muted रहते voice किसी session को कुछ नहीं सौंपता: आपने वह माँगा हो ही नहीं
  सकता, इसलिए तब का handoff voice का अपना है, उसे मिली lines पर आधारित, और app उसे बताता है कि कुछ नहीं
  सौंपा गया। **Unmute** के बाद फिर से कहें। band phase वैसी ही रखता है और `· muted` जोड़ता है; जब कोई line खुली न
  हो, menu "Muted — line closed" कहता है। Mute line बंद नहीं करता: खुली line सामान्य चुप्पी के बाद
  बंद होती है, जो आप बोल रहे थे तो Mute से गिनी जाती है, और line पहले से शांत थी तो तब बंद होती है
  जब Mute के बिना होती; वह किसी भी चुप्पी की तरह billed होती है, इसलिए Mute से realtime minutes नहीं
  बचते। **Unmute** microphone फिर लेता है, और न ले पाए (मना किया गया, busy, मौजूद नहीं) तो call कारण
  के साथ ख़त्म हो जाती है। **Stop** call और mute दोनों ख़त्म करता है; अगला **Start** unmuted शुरू
  होता है। Mute कोई ताला नहीं है: आपके user के रूप में चल रहा कोई भी process उसे हटा सकता है
  ([SECURITY.md](../../SECURITY.md#who-can-drive-the-bridge))।
- **Load context** तभी चालू होता है जब voice के पास target का कुछ हिस्सा नहीं है: सारांश नहीं है और **Pause sync** अगली line को उसे load करने से रोकता है या पिछली बार माँगा गया सारांश विफल रहा (session के अगले turn या अगले Start तक),
  कोई turn नहीं पहुँचा, कोई सवाल या permission notice app तक नहीं पहुँचा, mod बंद रहते turns चले,
  सारांश के बाद की पंक्तियाँ अब voice की क्षमता में पूरी नहीं समातीं (लंबी conversation इससे बढ़
  जाती है), session paused रहा है और उसका सारांश है, या उसका mod sync नहीं करता। नहीं तो यह item **Context up to
  date** दिखाता है और बंद रहता है, क्योंकि voice के पास conversation पहले से है। अगर कोई line खुली न हो, अगली line सारांश load करेगी और बाकी कुछ नहीं छूटा है, तो यह
  **Context loads with the line** दिखाता है और बंद रहता है, क्योंकि अगली line उसे खुद माँगती है। जब target का सारांश
  रास्ते में हो, उसे किसी ने भी माँगा हो, item **Loading context…** दिखाता है और बंद रहता है, ज़्यादा से ज़्यादा उतने समय तक जितना mod उसे देता है ([कितना](../../docs/architecture/overview.md#its-time); पुराने mod पर वह **Load context** ही रहता है); आया हुआ
  सारांश कुछ पल **Context loaded** दिखाता है, और खाली जवाब वापस **Load context** पर ले आता है। सारांश पर कोई तारीख
  नहीं होती, इसलिए वह अनदेखा हो सकता है जबकि item चालू रहता है ([BR-002](../../docs/bugs/BR-002.md))।
- **New conversation…** target की conversation और उसका loaded context मिटा देता है, और किसी session
  का × उसे हटाता है और उसकी अपनी conversation मिटा देता है; दोनों पहले पूछते हैं। Voice अगली बार
  line खुलने से नए सिरे से शुरू होता है। जो नतीजे उसने अभी नहीं बोले वे रहते हैं और फिर से जोड़े
  जाते हैं; उन्हें सिर्फ़ **Stop** मिटाता है। Claude के इंतज़ार कर रहे सवालों के नियम अलग हैं
  ([विवरण](../../SECURITY.md#residual-risk-by-design))। **Load a session's context on its first call** चालू हो, या **Pause sync** बंद हो और session paused न हो, तो
  अगली line उसी session के transcript का सारांश अपने-आप load करती है, जिसमें बातचीत का text है (इस
  release का app और mod tool output, thinking और reminders हटा देते हैं, पर उन्हें quote करने वाला
  text नहीं, और पुराना app या mod पूरी request भेजता है); इससे बचने के लिए पहले session में `/clear` करें, फिर **New conversation** दबाएँ। हटाए गए
  session में `/live` उसे फिर से जोड़ देता है।

### सेटिंग्स

**Settings…** LiveBridge की Settings window खोलता है, जिसके toolbar में चार tabs हैं।
menu का **Quick Settings** इसके पाँच switches रखता है ([menu](#बैंड-और-मेन्यू)): हर item वही setting
है, इसलिए एक जगह का बदलाव दूसरी जगह तुरंत दिखता है, और वह वही पूछता है जो यहाँ का switch पूछता है।
**General** में notifications, login, updates और debug mode हैं:

- **Notify when a result is waiting** (डिफ़ॉल्ट रूप से चालू): line बंद रहने पर इंतज़ार कर रहे नतीजे की
  chime के साथ, एक macOS notification session का नाम बताता है ("Alpha has a new result — speak to
  hear it"), नतीजा खुद कभी नहीं। उस पर click करने से menu bar menu खुलता है।
- **Open at login** (डिफ़ॉल्ट रूप से बंद)।
- **Updates**: चल रहा version, **Check for update**, **Check for updates automatically** और पिछले
  update ने क्या किया ([अपडेट करना](#अपडेट-करना))।
- **Debug mode** (डिफ़ॉल्ट रूप से बंद): call के दौरान हर सेकंड voice के network आँकड़ों की एक row
  (खोए और फेंके गए packets, jitter, concealed samples, line TCP पर चल रही है या नहीं), हर call की एक
  CSV, `~/Library/Application Support/LiveBridge/debug/call-stats/` में; न audio, न transcript, न
  session के नाम। call के दौरान चालू करने पर यह खुली line को उसी पल से दर्ज करता है; बंद करने पर
  तुरंत रुक जाता है, और files तब तक रहती हैं जब तक आप उन्हें न हटाएँ। **Show Debug Files** folder
  खोलता है। menu में यह **Feedback & Support** में **Debug Mode** है
  ([आँकड़े कैसे पढ़ें](../../CONTRIBUTING.md#reading-debug-modes-numbers))।

**Voice** में वह है जो आप call के दौरान सुनते हैं:

- **Voice**: आपका codex जो realtime voices देता है उनमें से एक, जिनकी सूची codex यह tab खुलने पर
  देता है, या **Codex default**। यह अगली बार line खुलने से सुनाई देती है।
- **Prompt** (डिफ़ॉल्ट रूप से खाली): voice के लिए आपके अपने निर्देश, जैसे "मुझसे Spanish में बात
  करो", अधिकतम 2,000 अक्षर। ये LiveBridge के अपने voice नियमों के बाद जोड़े जाते हैं, और दोनों में
  टकराव होने पर उन्हीं नियमों की चलती है, और अगली बार line खुलने से लागू होते हैं।
- **Play sounds for requests and answers** (डिफ़ॉल्ट रूप से चालू): voice जो भी अनुरोध Claude को सौंपता है,
  हर एक के लिए एक छोटी आवाज़ ([क्यों](known-limitations.hi.md)), और जब कोई बोल नहीं रहा हो तब खुली या खुलती
  line पर पहुँचने वाले Claude के हर जवाब, विफलता या सवाल के लिए भी एक। प्रतीक्षा कर रहे नतीजे की
  ध्वनि हर हाल में बजती है।

**Line** में यह है कि ख़ामोशी में line कितनी देर खुली रहती है और वह कैसे जुड़ती है:

- **Silence before the line closes** (डिफ़ॉल्ट रूप से 20 सेकंड), **Wait for a first word on a line
  a result opened** (10 सेकंड) और **Sound without words before the line closes** (90 सेकंड): हर तरह
  की चुप्पी खुली line को कितनी देर खुला रखती है, 0 से 300 सेकंड तक। 0 चुप्पी या शब्दों के बिना आवाज़
  वाले timer को बंद कर देता है, और पहले शब्द की प्रतीक्षा 0 पर हो तो वह चुप्पी जितनी ही देर चलती है।
  तीनों 0 हों तो चुप्पी line को कभी बंद नहीं करती: वह खुली रहती है, और पूरे समय उसका बिल बनता है
  ([बिलिंग](#बिलिंग-का-ध्यान-रखने-वाला-डिज़ाइन)), जब तक आप Stop न दबाएँ, target न बदलें या OpenAI उसे
  बंद न कर दे। छोटी चुप्पी सामान्य ठहरावों के बीच ही line बंद कर देती है, और हर बार line दोबारा खुलने
  पर voice के जवाब देने में कुछ सेकंड लगते हैं, इसलिए 1 से 9 सेकंड पर Settings चेतावनी देता है;
  शब्दों के बिना आवाज़ के लिए भी वह ऐसा ही करता है, क्योंकि पहचाने जाने तक आपकी बोली उसी में गिनी
  जाती है, और पहले शब्द के लिए 1 से 3 सेकंड पर, क्योंकि voice अक्सर line connect होने के लगभग 2 सेकंड
  बाद बोलना शुरू करता है। जो timer आप चालू करते हैं, वह शांत खुली line पर तुरंत शुरू हो जाता है; जो
  पहले से गिन रहा है, वह अपना समय बनाए रखता है।
- **Connect over TCP** (डिफ़ॉल्ट रूप से बंद): अगर खराब connection पर voice टूटती है, तो इसे चालू
  करें। तब line UDP के बजाय media server के दिए TCP रास्ते (देखे गए answers में port 443) को
  प्राथमिकता देती है, और फिर भी UDP पर लौट सकती है। packets खोने वाले connection पर इससे टूटन
  phrases के बीच छोटे ठहराव बन सकती है ([यह कितना परखा गया](known-limitations.hi.md))। बदलते समय खुली line
  आपकी पुष्टि के बाद तुरंत बंद होकर फिर खुलती है; voice जो कह रही थी वह कट जाता है, और line जिस
  नतीजे का इंतज़ार कर रही थी वह फिर भी नई line में आता है।

**Context** में यह है कि आपके sessions voice तक कैसे पहुँचते हैं:

- **Pause sync while the call is stopped** (डिफ़ॉल्ट रूप से बंद): डिफ़ॉल्ट रूप से, जुड़े हुए session
  में आप जो टाइप करते हैं और उस पर Claude का अंतिम जवाब, call रुकी होने पर भी voice के साथ उस
  session की conversation में रखे जाते हैं, और अगली line खुलने पर voice के पास होते हैं। line खुलने
  तक इसमें से कुछ भी OpenAI तक नहीं पहुँचता। जिस text को आप OpenAI तक नहीं पहुँचाना चाहते, उसके लिए setting चालू
  करें, अगर session का सारांश शायद अभी न हो तो अगली setting बंद करें, Stop दबाएँ, फिर टाइप करें: call रुकी होने पर आप जो टाइप करते हैं वह दर्ज नहीं होता, और
  session paused चिह्नित हो जाता है। यह चालू रहते कोई line अपने-आप सारांश load नहीं करती, और pause
  के बाद भी नहीं, सिवाय ऐसे session के जिसका सारांश नहीं है (अगली setting); बाकी समय यह सिर्फ़ **Load context**
  करता है। वह सारांश
  transcript से लिखा जाता है, इसलिए उसमें वह आता है जिसे आपने pause किया था। जिस turn में voice
  अनुरोध चल रहा हो, उसमें टाइप करने से उसका जवाब विफल हो जाता है, उसका कुछ भी दर्ज या बोला नहीं
  जाता। यह पहले से दर्ज किसी चीज़ को नहीं हटाता, और Claude के बाद के जवाब paused text दोहरा सकते
  हैं; यह क्या करता है और क्या नहीं, यह [SECURITY.md](../../SECURITY.md#residual-risk-by-design) में है।
- **Load a session's context on its first call** (डिफ़ॉल्ट रूप से चालू; update के समय **Pause sync** चालू था तो बंद): जिस session का
  सारांश voice के पास नहीं है, उसके लिए Start, call के दौरान target बदलना या खुलने वाली line सारांश
  माँगती है, चाहे **Pause sync** चालू हो या
  session paused हो, पुरानी chat और **New conversation** के बाद की chat समेत। वह सारांश transcript से
  लिखा जाता है, इसलिए उसमें वह आता है जिसे आपने pause किया था, और वह OpenAI को जाता है। session का सारांश
  बन जाने के बाद जो आगे होता है उस पर pause लागू होता है। यह बंद हो तो pause में सिर्फ़ **Load context** सारांश
  load करता है।
- **Summary model** (डिफ़ॉल्ट Haiku 5.5, update के बाद भी; या Sonnet 5.5, Opus 5.5 या **Custom…**): वह model जो
  voice को context के रूप में मिलने वाला सारांश लिखता है, हमेशा low effort पर, आपके Claude usage से।
  कोई दूसरा model विफल हो तो Haiku 5.5 उसे लिखता है, जब तक उस model का समय खत्म न हुआ हो। इसके नीचे एक पंक्ति बताती है कि पिछला सारांश कब
  Haiku 5.5 से आया, या किसी model से नहीं आया, और क्यों। इस setting से पहले के mod पर चल रहा session इसे
  अनदेखा करता है और session के अपने model से लिखता है। **Custom…** एक model id और **Check and save** लेता है: कोई
  जुड़ा हुआ session उस model को आपके Claude usage से एक छोटा request ("Reply with OK.") भेजता है, और id
  तभी save होता है जब model जवाब दे; नहीं तो कारण field के पास दिखता है और पिछला चुनाव बना रहता है।
  इसके लिए इस version के mod वाला session चाहिए, और जाँच उसी session के Claude Code की बात कहती है: दूसरा
  session अलग हो सकता है, और save किया गया id दोबारा नहीं जाँचा जाता।

### वॉइस क्या करता है

- वह छोटी-मोटी बातचीत और स्पष्टीकरण खुद देता है, और जिस भी चीज़ के लिए repository या session चाहिए,
  उसे आगे सौंप देता है: tasks, code के बारे में सवाल, फ़ैसले, सुधार और रोकना।
- कुछ भी विनाशकारी या बाहर की ओर जाने वाला (delete, push, publish, send, deploy, pay) सौंपने से पहले
  वह अनुरोध दोहराता है और पूछता है "yes?"। यह voice को सिखाई गई एक आदत है, कोई सुरक्षा उपाय नहीं;
  [SECURITY.md](../../SECURITY.md) बताता है कि सुरक्षा उपाय क्या है।
- वह नतीजे session के नाम के साथ एक-दो वाक्यों में पढ़कर सुनाता है। Code blocks और tables session में
  ही रहते हैं, और जो credentials वह पहचान लेता है उन्हें छिपा (redact) दिया जाता है।
- Claude का काम पूरा होने पर वह लौट आता है। line खुली रखने की ज़रूरत नहीं: बातचीत शांत होने पर line
  बंद हो जाती है, और आपके अनुरोध पर Claude का जवाब उसे फिर से खोलता है और voice को बोलने के लिए दिया
  जाता है, इसलिए Claude के काम करते समय आप जा सकते हैं। यह उस session के लिए है जिससे आप बात कर रहे
  हैं; दूसरे session का नतीजा chime बजाकर इंतज़ार करता है ([billing कैसे होती
  है](#बिलिंग-का-ध्यान-रखने-वाला-डिज़ाइन))। अगर फिर से खुली line पर voice चुप रहे, तो जवाब भी chime
  बजाकर इंतज़ार करता है, इसलिए वह खोता नहीं। Claude का आपसे पूछा गया सवाल या जिस permission prompt
  का वह इंतज़ार कर रहा है, वह line को उसी तरह खोलता है, पर voice उसे शायद न बोले: Mac से दूर होने पर
  इस पर भरोसा न करें ([ज्ञात सीमाएँ](known-limitations.hi.md))।
- जब Claude कोई सवाल पूछता है, तो वह voice को आपके सामने रखने के लिए दिया जाता है और आपका जवाब उसी
  session को वापस जाता है। Claude काम करते हुए जो सवाल पूछता है (विकल्पों वाला dialog), उसके साथ भी
  ऐसा ही होता है: voice को वह इसलिए दिया जाता है कि वह आपको उसके बारे में बताए, विकल्पों को अपने
  शब्दों में समझाए और जब तक आप चाहें आपसे उन पर बात करे, Claude से पूछे बिना। आप जो तय करते हैं, कोई
  विकल्प या Claude से वापस कोई सवाल, वही dialog का जवाब बनता है; आप चाहें तो keyboard पर भी जवाब दे
  सकते हैं। Claude जो काम बाद में background में पूरा करता है, वह update के रूप में voice को जाता
  है।
- जब Claude किसी permission prompt का इंतज़ार कर रहा हो, तो voice को एक notice दिया जाता है और वह यह
  बता सकता है, सिवाय [वहाँ जहाँ कोई organization Claude Code को manage करता है](known-limitations.hi.md)।
  Prompt का जवाब आप Claude Code में देते हैं; LiveBridge उसका जवाब कभी आपकी जगह नहीं देता।
- आप जो टाइप करते हैं, वह उसे दिया जाता है। session के जुड़े रहते, आप उसमें जो टाइप करते हैं और हर
  उस turn पर Claude का अंतिम जवाब जो voice अनुरोध नहीं था, उस session की voice के साथ conversation
  में context के रूप में जाते हैं ([इसकी सीमाएँ](known-limitations.hi.md))। आप जो टाइप करते हैं, उसके
  लिए chime नहीं बजता और वह बंद line नहीं खोलता। जिस turn में आपने टाइप किया, उस पर Claude का जवाब,
  target session में और call चालू रहते, नतीजे की तरह बोला जाता है: वह बंद line खोलता है, या उस
  session के बारे में खुली line पर बोला जाता है; जिस turn में आपने कुछ टाइप नहीं किया, जैसे किसी
  दूसरे session का संदेश, उसका जवाब context ही रहता है। कोई client आपके भेजे में जो
  `<system-reminder>` blocks जोड़ता है, जैसे side sessions पर desktop app के notes, वे आपके शब्द नहीं
  हैं और छोड़ दिए जाते हैं; अकेले भेजी गई image में रखने लायक कुछ नहीं बचता। खुली line को वे तुरंत मिलते हैं; बाद में खुली line उनसे शुरू होती है। जिस
  voice जवाब को नए अनुरोध ने हटा दिया, वह बोला नहीं जाता, पर रखा जाता है और उसी तरह जोड़ा जाता है।
  turn के बीच का Claude का text sync नहीं होता, सिवाय उसके जो उसने सवाल या permission prompt से ठीक
  पहले लिखा, वह उसी के साथ जाता है; subagents और tools का output भी sync नहीं होते। target में
  Claude का सवाल या permission prompt voice को दिया जाता है, चाहे उसे किसी भी turn ने पैदा किया हो;
  किसी दूसरे session में वह वैसे ही जाता है जैसे वहाँ का नतीजा जाता, सिवाय इसके कि जो turn voice
  अनुरोध नहीं था, उसका सिर्फ़ दर्ज होता है। जिस turn को pause बाहर रखता है, उसमें इनमें से कुछ नहीं
  होता। जब कोई सवाल या prompt voice के बिना निपट जाता है, या कोई turn बिना जवाब के ख़त्म होता है, तो
  voice को यह बताने वाली पंक्ति दी जाती है ([कौन-सी
  पंक्तियाँ](../../SECURITY.md#what-session-text-can-do))।

## बिलिंग का ध्यान रखने वाला डिज़ाइन

Realtime voice session खुली रहने तक खर्च होता है, इसलिए LiveBridge उसे सिर्फ़ तभी खोलता है जब कोई
बोल रहा हो, जब आपके अभी किए गए अनुरोध पर Claude का जवाब आना बाकी हो, या उस जवाब, Claude के
सवाल या इस बात को सुनाने के लिए कि Claude आपकी अनुमति का इंतज़ार कर रहा है:

- जब call चालू हो और कोई बोल नहीं रहा, तब microphone सिर्फ़ आपके Mac पर चल रहे voice detector को
  audio देता है। कहीं कोई audio भेजा नहीं जाता।
  Muted रहते हुए LiveBridge के पास कोई microphone नहीं होता, और macOS का microphone indicator यह दिखाता है।
- जब आप बोलना शुरू करते हैं, line खुल जाती है। बोलना शुरू करने से पहले के 2 सेकंड रखे जाते हैं और
  सबसे पहले भेजे जाते हैं, ताकि आपके पहले शब्द न छूटें।
- कुछ देर की चुप्पी के बाद line बंद हो जाती है, और शब्दों के बिना आवाज़ (संगीत, TV) उसे अपनी अलग
  अवधि के बाद बंद करती है। दोनों [सेटिंग्स](#सेटिंग्स) में अलग-अलग तय होते हैं; जो 0 पर हो, वह उसे बंद नहीं करती।
- जब voice कोई अनुरोध Claude को सौंपता है (handoff), तो उस handoff के बाद line अधिकतम 2 मिनट तक खुली
  रहती है, जिसका बिल किसी भी खुली line की तरह बनता है, और जब कोई बोल नहीं रहा होता तब Claude का जवाब
  voice को सुनाने के लिए दिया जाता है। अगला handoff 2 मिनट फिर से शुरू करता है; जिस बातचीत में
  Claude को कुछ नहीं भेजा जाता, वह सामान्य चुप्पी के बाद बंद हो जाती है।
- जिस session से आप बात कर रहे हैं, उसे दिए गए अनुरोध पर Claude का जवाब, उसमें Claude का आपसे पूछा
  गया सवाल, या वह permission prompt जिसका वह इंतज़ार कर रहा है, line बंद होने के बाद आए तो line फिर
  से खोलता है और voice को सुनाने के लिए दिया जाता है; इसका खर्च किसी भी खुली line जैसा है। line बंद
  रहते आने वाली बाकी हर चीज़ (उस session से आई कोई भी चीज़ जिससे आप हट गए, बाद का update) chime
  बजाती है और इंतज़ार करती है: band और menu उसे न सुना हुआ दिखाते हैं, और जब आप अगली बार बोलते हैं
  तो वह voice को जाती है ([कब माना जाता है कि सुन लिया
  गया](../../docs/architecture/overview.md#a-result-while-the-line-is-closed))।
- हर Claude Code session की voice के साथ अपनी अलग conversation होती है। वह अगले realtime session में
  आगे ले जाई जाती है, और Stop और Start के पार भी, ताकि voice को याद रहे कि आपने एक मिनट पहले क्या
  कहा था। नया target conversation बदल देता है: खुली line बंद हो जाती है, और आपके अगले शब्द उसे नए target
  की conversation के साथ खोलते हैं।
- Menu वे मिनट दिखाता है जितनी देर line खुली रही, जिन्हें app voice के connect होने से गिनता है,
  इसलिए आपका plan थोड़ा ज़्यादा गिन सकता है। OpenAI desktop voice की कीमत आपके Codex usage budget के
  प्रति मिनट के हिसाब से तय करता है, और उसके API पर मॉडल का वही परिवार मौन का भी बिल बनाता है
  ([विवरण](../../docs/research/2026-11-04-gpt-live-billing.md),
  [सीमाएँ](../../docs/research/2026-11-05-gpt-live-limits.md)); आपके plan का अपना usage page ही प्रामाणिक
  है।
- Menu दिखाता है कि आपके Codex और Claude usage का कितना हिस्सा इस्तेमाल हो चुका है: हर एक की एक
  पंक्ति, plan जितनी windows बताता है उनमें से हर एक का इस्तेमाल हुआ प्रतिशत (हर पंक्ति में अधिकतम
  तीन, जैसे `7% of 5 h · 19% of week`), 90 % या उससे अधिक होने पर नारंगी; किसी पंक्ति पर hover करने
  से हर window के reset होने का समय दिखता है। Codex के आँकड़े हर बार menu खुलने पर, अधिकतम मिनट में
  एक बार, एक अल्पकालिक codex से पढ़े जाते हैं; Claude के आँकड़े किसी जुड़े हुए session से तब आते हैं जब
  वह जवाब दे चुका हो। जिस पंक्ति में दिखाने को कुछ न हो वह छोड़ दी जाती है, और codex जब बताता है कि
  सामान्य उपयोग की अनुमति नहीं है तब Codex की पंक्ति में `blocked` लिखा आता है। Codex की आख़िरी reading तुरंत दिखती है और कुछ सेकंड बाद नई reading उसकी जगह ले लेती है, इसलिए menu खुला
  रहते आँकड़े बदल सकते हैं; launch के ठीक बाद पंक्ति पहली reading आने पर दिखती है, और पढ़ना विफल होने पर
  reading 15 मिनट बाद हट जाती है।
  कौन-सी limit voice को
  सबसे पहले रोकती है, यह प्रकाशित नहीं है ([विवरण](../../docs/research/2026-11-05-gpt-live-limits.md))।

## अपडेट करना

LiveBridge app और अपने mod को तभी update करता है जब आप **Install** click करें, अपने-आप कभी नहीं।
सिर्फ़ `/Applications/LiveBridge.app` वाली copy update होती है; कोई और copy Settings में यही बताती
है।

- **Check for updates automatically**, Settings में (डिफ़ॉल्ट रूप से चालू, source से बने build के
  लिए बंद): दिन में एक बार app GitHub से पूछता है कि नवीनतम release कौन-सा है। नए release की सूचना
  एक ही बार दी जाती है, एक notification से जिसका **Install** उसे install करता है, और menu bar menu
  में **Install LiveBridge X.Y.Z…** तब तक रहता है जब तक वह install न हो जाए; इस item को बनाए रखने के
  लिए app हर launch पर GitHub से फिर पूछता है। Settings का **Check for update** तुरंत पूछता है।
- **Install** के लिए [GitHub CLI](https://cli.github.com) में login होना चाहिए (`gh auth login`);
  इसके बिना Install कुछ भी download नहीं करता और release page का link देता है। यह release की image
  download करता है, उसे उसी `gh attestation verify` से जाँचता है जो
  [डिस्क इमेज से](README.hi.md#डिस्क-इमेज-से) में है, फिर उसके अंदर के app को
  जाँचता है, और जब तक हर जाँच पास न हो, कुछ install नहीं करता। जब तक Claude किसी voice request पर
  काम कर रहा हो, यह इंतज़ार करता है, `claude plugin marketplace update livebridge` और
  `claude plugin update livebridge@livebridge` से mod update करता है, call रोकता है, नए app को एक ही
  step में उसकी जगह रखता है और उसे खोलता है।
- इसके बाद Settings बताता है कि update किस version से हुआ। अगर mod update नहीं हो सका, तो वहाँ ये
  दोनों commands दिखते हैं ताकि आप इन्हें खुद चलाएँ। पहले से खुले Claude Code sessions restart होने
  तक पुराना mod ही रखते हैं; Settings उन जुड़े sessions को दिखाता है जो अब भी उसे चला रहे हैं।
- update का download कोई quarantine attribute नहीं लगाता, इसलिए macOS को updated app का पहला launch
  पूछने के लिए वैसे नहीं रोकना चाहिए जैसे पहले download के बाद रोका था; यह code से निकलता है और अभी असल
  में देखा नहीं गया है। उसकी जगह ऊपर वाली जाँचें लेती हैं
  ([SECURITY.md](../../SECURITY.md#what-an-update-installs))। 0.4.2 के बाद के releases LiveBridge की
  Developer ID से signed हैं, इसलिए microphone की अनुमति एक release से अगले में जानी चाहिए; यह इस पर आधारित है कि macOS
  अनुमति को कैसे जोड़ता है, और अभी तक देखा नहीं गया है। 0.4.2 और उससे
  पहले के releases ad hoc signed थे, इसलिए उनमें से किसी से पहला update पहले **Start** पर microphone के लिए
  एक बार फिर पूछता है।

हाथ से update करने के लिए, हर session में `/live off` चलाएँ (app जवाब देना बंद करते ही mod
`/Applications` वाला app फिर खोल देता है), LiveBridge बंद करें, नई image
[इंस्टॉल करना](README.hi.md#इंस्टॉल-करना) में बताए तरीके से install
करें और दोनों `claude plugin` commands चलाएँ।

## अनइंस्टॉल करना

`/Applications` वाली copy में menu का **Feedback & Support ▸ Uninstall LiveBridge…** पहले
पूछता है और app को Trash में ले जाता है; अगर न ले जा सके, तो यह बताता है, app को वहीं रहने देता है और पहले हटाया गया login item, अगर कोई था, वापस लगा देता है, और अगर macOS उसे वह login item वापस लगाने नहीं देता, तो यह भी बताता है, और **Open at login** को फिर से चालू कैसे करें, यह भी। फिर खुली call खत्म होती है और हर session LiveBridge छोड़ देता है, जैसे menu के × से,
इसलिए उसमें `/live` LiveBridge को फिर से खोलने के बजाय बंद हो जाता है; LiveBridge login item और
microphone permission हटाकर बंद हो जाता है, और उसके बंद होने के बाद उसकी files (नीचे दी गई)
Trash के एक folder में चली जाती हैं, जब तक आप उसे खाली न करें। Claude Code का mod बना
रहता है: उसे हटाने वाला command, `claude plugin uninstall livebridge@livebridge`, copy हो
जाता है ताकि आप उसे Terminal में चलाएँ। जो session तब खुला नहीं था, वह खुलने पर फिर से
LiveBridge ढूँढ सकता है; mod हटाने से यह रुक जाता है।

Homebrew से install किया था? `brew uninstall --cask getlivebridge/tap/livebridge` app और Homebrew का उसका record हटा देता
है; app की files के लिए नीचे के steps फिर भी लागू हैं।

किसी clone से, `scripts/build-app.sh --uninstall` `/Applications/LiveBridge.app` को हटा देता है,
चाहे वह जैसे भी install हुआ हो, साथ ही उसका login item और उसकी रखी हर फ़ाइल, और वे दो commands
प्रिंट करता है जो वह आपके लिए छोड़ देता है: `tccutil reset Microphone com.getlivebridge.livebridge` और
`claude plugin uninstall livebridge@livebridge`।

Clone के बिना, LiveBridge की Settings में **Open at login** बंद करें, LiveBridge को quit करें, और
Terminal में वही steps चलाएँ:

```sh
rm -rf /Applications/LiveBridge.app ~/Library/Application\ Support/LiveBridge \
  ~/Library/{Caches,WebKit}/com.getlivebridge.livebridge \
  ~/Library/HTTPStorages/com.getlivebridge.livebridge{,.binarycookies} \
  ~/Library/Preferences/com.getlivebridge.livebridge.plist
tccutil reset Microphone com.getlivebridge.livebridge
claude plugin uninstall livebridge@livebridge
```

इनमें से कोई भी तरीका `/Applications/.LiveBridge-update-….app` नाम की copy नहीं हटाता, जो install के
बीच में रुका update छोड़ सकता है। app ऐसी copies अगले launch पर हटा देता है; uninstall के बाद, अगर
ऐसी copy हो तो उसे हाथ से हटाएँ।

`claude plugin uninstall` शायद mod का snapshot, `~/.claude/plugins/store/livebridge_*.json`, छोड़
दे: Claude Code की documentation में जो हटता है उसकी सूची में यह file नहीं है, और यह चलाकर नहीं देखा
गया। अगर वह मौजूद हो तो उसे हाथ से मिटा दें।
