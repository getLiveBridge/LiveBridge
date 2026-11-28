# ज्ञात सीमाएँ

*अंग्रेज़ी पाठ ही मूल है ([known-limitations.md](../known-limitations.md)); यह अनुवाद पीछे रह सकता है।*

LiveBridge क्या नहीं करता, या केवल आंशिक रूप से करता है, हर मापे गए बिंदु के पीछे के record के साथ।
सारांश [README](README.hi.md#ज्ञात-सीमाएँ) में है, और यहाँ बताई गई settings [guide.hi.md](guide.hi.md) में।

- **Connect over TCP** TCP को प्राथमिकता देता है, उसे मजबूर नहीं करता, और call के दौरान कुछ नहीं दिखाता कि line
  ने कौन-सा transport लिया, इसलिए UDP पर लौटी line अब भी टूट सकती है। यह रास्ता एक बार मापा गया, एक
  debug build में जिसने UDP candidates हटा दिए थे (10 मिनट में कोई audio नहीं खोया); भेजा गया तरीका,
  उनकी priority घटाना, एक बार TCP चुनते देखा गया। debug mode transport दर्ज करता
  है (`onTcp`) ([CONTRIBUTING.md](../../CONTRIBUTING.md#reading-debug-modes-numbers))।
- voice कभी-कभी कहता है कि वह देख रहा है ("On it", "Looking now"), पर अनुरोध Claude को नहीं सौंपता,
  इसलिए Claude तक कुछ नहीं पहुँचता: पहले लिखे गए नियम के साथ लगभग पाँच में से एक अनुरोध, और अब के
  नियम के साथ 20 में से 0, जो किस्मत से अलग बताने के लिए बहुत कम है ([BR-001](../../docs/bugs/BR-001.md))।
  वह ऐसे काम का दावा भी कर सकता है जो उसने नहीं किया, जैसे "I'll take a look.", उन पंक्तियों पर भी
  जो उसके पास सिर्फ़ context के रूप में हैं ([ADR 0001 (n),
  (o)](../../docs/adr/0001-platform-findings.md))। जब app किसी अनुरोध को Claude की queue में डालता है, तो
  एक छोटी आवाज़ बजती है, जो जवाब की आवाज़ से अलग है; अगर voice कहे कि वह देख रहा है और यह आवाज़ न
  बजे, तो अनुरोध दोबारा कहें।
  app शब्दों से ऐसे वादे और जवाब में फ़र्क नहीं कर सकता, क्योंकि voice आपकी भाषा में बोलता है।
- Claude का सवाल, या वह permission prompt जिसका वह इंतज़ार कर रहा है, सिर्फ़ voice को दिया जाता है,
  और voice उसे शायद न बोले; उसे कोई मजबूर नहीं करता। इसलिए Mac से दूर होने पर voice के prompt बताने
  पर भरोसा न करें: Claude बिना किसी सूचना के इंतज़ार करता रह सकता है। Prompt फिर भी Claude Code में
  इंतज़ार करता है, और वही एकमात्र नियंत्रण है; voice नियंत्रण नहीं है, और LiveBridge prompt का जवाब
  कभी नहीं देता। जाँचों में, खुली line पर टाइप किए गए turn का permission notice keyboard के जवाब से
  पहले 3 में से 0 runs में बोला गया, यह गिनती है, दर नहीं ([ADR 0001
  (n)](../../docs/adr/0001-platform-findings.md))। बंद line इनके लिए तभी खुलती है जब target की
  conversation में आपका कोई turn हो; नहीं तो app chime बजाता है, और call बंद हो तो ये सिर्फ़ दर्ज
  होते हैं।
- Claude desktop app टाइप किए गए prompt का origin क्या बताता है, यह देखा नहीं गया ([ADR 0001
  (m)](../../docs/adr/0001-platform-findings.md))। mod किसी prompt को आपका तभी दर्ज करता है जब उसका origin
  `composer` हो। अगर वहाँ टाइप किया prompt किसी और रूप में आए, तो वहाँ टाइप किया कुछ भी दर्ज नहीं
  होता, कोई gap चिह्नित नहीं होता, menu **Context up to date** कहता है, और pause कम पहुँचता है
  ([विवरण](../../SECURITY.md#what-session-text-can-do))।
- जो नतीजा तब आता है जब line उसका इंतज़ार कर रही हो, वह voice को बोलने के लिए text के रूप में जाता
  है; codex में ऐसा कोई call नहीं है जो voice को तुरंत बुलवाए, इसलिए कब बोलना है यह model तय करता
  है। end-to-end smoke test ([scripts/smoke.sh](../../scripts/smoke.sh)) जाँचता है कि voice ऐसा नतीजा
  आपके अगले शब्दों से पहले कह दे; वह कितनी जल्दी बोलता है, यह मापा नहीं गया। अगर नहीं बोलता, तो
  नतीजा न सुना हुआ रहता है: वह
  आपके अगले शब्दों के साथ फिर voice को जाता है, या line बंद होने पर chime बजती है।
- जब Claude का जवाब line को फिर से खोलता है, तो voice चुप रह सकता है: मापे गए 14 में से 4 runs में
  ऐसा हुआ, जो छोटा नमूना है ([ADR 0001 (n)](../../docs/adr/0001-platform-findings.md))। तब line पहले शब्द की
  प्रतीक्षा ख़त्म होते ही बंद हो जाती है ([सेटिंग्स](guide.hi.md#सेटिंग्स)), और जवाब chime बजाकर इंतज़ार करता है,
  जैसा नीचे बताया गया है। जहाँ voice बोला, वहाँ उसने connect के लगभग 2 सेकंड के भीतर बोलना शुरू किया;
  जो voice उस प्रतीक्षा के बाद शुरू होता, वह कट जाता है।
- जब आपके अगले शब्द line को फिर से खोलते हैं, तो voice कभी-कभी सिर्फ़ उन्हीं का जवाब देता है और
  इंतज़ार कर रहा नतीजा नहीं सुनाता। नतीजा खोता नहीं है: वह इंतज़ार में रहता है, line बंद होने पर chime
  बजाता है और notification भेजता है, और अगली बार line खुलने पर फिर से voice को जाता है।
- आपके ChatGPT plan की usage limit पर voice तब तक रुक जाता है जब तक limit reset न हो। Menu और band
  यह बताते हैं, codex के वाक्य में और जहाँ codex दे वहाँ reset के समय के साथ, और call खत्म हो जाती
  है, ताकि बोलने से विफल होने वाली lines न खुलें। Claude Code काम करता रहता है, जवाब इंतज़ार करते
  रहते हैं, और Start एक बार फिर कोशिश करता है। app किसी limit को सिर्फ़ codex के शब्दों या service
  के error code से पहचानता है, क्योंकि और कुछ यह नहीं बताता
  ([विवरण](../../docs/research/2026-11-05-gpt-live-limits.md))। जिस इनकार को वह नहीं पहचानता, जैसे बिना
  कारण बताए गिरी हुई line ("The voice session closed (transport_closed)."), उसमें call चालू रहती है,
  इसलिए आपके अगले शब्द फिर कोशिश करते हैं; limit reset होने तक **Stop** दबाएँ।
- जो prompt composer में टाइप नहीं किया गया (host का संदेश, schedule, दूसरा agent और शायद Remote
  Control), वह voice की conversation में आपके शब्दों के रूप में दर्ज नहीं होता, हालाँकि उस पर Claude
  का जवाब दर्ज होता है, और pause में वह चल रहे turn को अस्वीकार नहीं करता
  ([SECURITY.md](../../SECURITY.md#what-session-text-can-do) बताता है कि कौन-से prompt आपके माने जाते
  हैं)।
- जहाँ Claude Code का provider (Bedrock, Vertex या Foundry) **Summary model** में चुना model नहीं देता,
  या organisation उसकी अनुमति नहीं देता, वह model विफल होता है और Haiku 5.5 सारांश लिखता है; जहाँ Haiku 5.5
  भी नहीं मिलता, voice को सारांश नहीं मिलता, जो Settings बताती है। इस setting से पहले session का अपना model
  उसे लिखता था, जो हर उस जगह काम करता है जहाँ session करता है। pinned id का इन providers पर resolve होना
  Claude Code के documentation से लिया गया है और चलाकर नहीं देखा गया।
- जो session अब भी इस release से पहले के mod पर है, वह restart होने तक sync नहीं होता: वह turns छूटे
  session की तरह सारांश load करता है, और कोई pause उसकी पंक्तियों को अस्वीकार नहीं करता ([और क्या
  अलग है](../../CHANGELOG.md))।
- जो Claude Code session mod के load होने से पहले ही खुला था, उसमें `/live` चलने से पहले उसे दोबारा
  खोलना पड़ सकता है।
- Claude desktop app में, ऐसे session में टाइप किया गया `/live` जिसका Claude Code process अभी शुरू
  नहीं हुआ है (नया session, या अभी-अभी दोबारा खोला गया), "/live isn't a command here." दिखा सकता है।
  Command फिर भी चलता है। Desktop ऐसे session के commands की सूची एक ऐसी जाँच से बनाता है जो hooks
  बंद करके चलती है, इसलिए mod का code, जो `/live` घोषित करता है, वहाँ नहीं चलता; session चलने लगने के
  बाद desktop सूची session से ही लेता है। mod के पास इसका कोई समाधान नहीं है: एक static command फ़ाइल
  `/livebridge:live` के रूप में सूचीबद्ध होती, `/live` के रूप में नहीं, और hooks बंद होने पर वह अपना text
  mod चलाने के बजाय model को भेज देती।
- किसी जवाब ने इंतज़ार कर रहे नतीजे को बताया या नहीं, इसका फ़ैसला उसके शब्दों से होता है, सिर्फ़
  अंग्रेज़ी और रूसी के आम शब्दों की सूची के साथ
  ([नियम](../../docs/architecture/overview.md#a-result-while-the-line-is-closed))। किसी दूसरी भाषा में, अगर
  voice ने नतीजे का सिर्फ़ ज़िक्र किया हो, तब भी वह सुना हुआ गिना जा सकता है।
- जहाँ कोई organization Claude Code को manage करता है, वहाँ LiveBridge में कुछ भी आपको नहीं बताता
  कि कोई permission prompt इंतज़ार कर रहा है। Claude Code का built-in guard managed settings वाली
  machine पर और Team या Enterprise plan से sign in की गई session में load होता है, और वहाँ mod के
  permission hooks नहीं चलते। Prompt फिर भी Claude Code में दिखता है और आपका इंतज़ार करता है,
  लेकिन voice उसके बारे में कुछ नहीं कहता और menu दिखाता है कि Claude काम कर रहा है, इसलिए अगर
  जवाब में देर लगे तो Claude Code देखें। `/plugin` उन hooks के नाम बताता है, और Claude Code के हाल
  के versions एक line भी दिखाते हैं कि hook छोड़ दिया गया। Claude के सवाल फिर भी voice तक पहुँचते
  हैं। Hooks को एक Linux container में [मापा गया](../../docs/adr/0001-platform-findings.md); voice और
  menu bar क्या करते हैं, यह code से निकलता है, और कोई असली line नहीं चलाई गई। Team और Enterprise
  का मामला Claude Code के documentation से लिया गया है।
- Managed settings में `allowManagedHooksOnly`, `allowManagedModsOnly` या `disableAllHooks` होने
  पर mod load नहीं होता और `/live` काम नहीं करता। Administrator [mod को organization के अपने mod
  के रूप में install कर सकता
  है](https://code.claude.com/docs/en/plugins/mods/admin#install-your-organizations-mods), हर
  machine के एक folder से: तब permission hooks चलते हैं, पहली दो settings के साथ भी ([मापा
  गया](../../docs/adr/0001-platform-findings.md))। Claude Code के documentation के अनुसार, managed
  settings में marketplace की copy चालू करना काफ़ी नहीं है।
