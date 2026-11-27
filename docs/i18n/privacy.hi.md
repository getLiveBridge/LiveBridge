# गोपनीयता

*अंग्रेज़ी पाठ ही मूल है ([privacy.md](../privacy.md)); यह अनुवाद पीछे रह सकता है।*

OpenAI और GitHub तक क्या पहुँचता है, और LiveBridge आपके Mac पर क्या रखता है। सारांश
[README](README.hi.md#गोपनीयता) में है, और threat model [SECURITY.md](../../SECURITY.md) में।

LiveBridge में कोई telemetry नहीं है और वह किसी network port पर listen नहीं करता; mod, app से एक Unix
socket पर बात करता है, जो ऐसे folder में है जिसे केवल आपका user खोल सकता है। codex के realtime
session के ज़रिए OpenAI को यह जाता है:

- line खुली रहने के दौरान microphone audio, आपके बोलना शुरू करने से 2 सेकंड पहले से (या, Claude के
  जवाब, सवाल या permission prompt से खुली line के लिए, उसके खुलने से) लेकर line बंद होने तक (muted
  रहते LiveBridge कुछ capture नहीं करता, इसलिए कुछ नहीं जाता; Mute दबाने से पहले आपने जो बोला, जो
  line पहले से connect हो रही थी उस पर, वह फिर भी जा सकता है);
- voice के निर्देश: LiveBridge के अपने नियम, फिर आपकी Settings का **Prompt**, अगर आपने लिखा हो;
- target session की हाल की conversation (आख़िरी 64 पंक्तियों तक, और उससे ज़्यादा नहीं जितना codex
  लेता है: context और खुले कामों समेत 128 items और लगभग 8,192 tokens), ताकि उसे नए realtime session
  में जारी रखा जा सके। इसमें वह है जो आपने उस session में टाइप किया और हर उस turn पर Claude का अंतिम
  जवाब जो voice अनुरोध नहीं था, चाहे वह किसी से भी शुरू हुआ हो (आपका टाइप किया turn, कोई schedule,
  दूसरा agent, कोई background task), साथ में mod के notes और आपकी और voice की बोली, इसलिए किसी
  session में टाइप करना उसे OpenAI तक पहुँचा देता है जब उस session के साथ line खुलती है। line खुली
  रहते target की हर नई पंक्ति तुरंत उसमें जाती है। दूसरे session की sync की गई पंक्तियाँ तभी जाती
  हैं जब line उसके साथ target के रूप में खुलती है; उसके नतीजे, सवाल और approval notices खुली line
  में जाते हैं, चाहे वह कोई भी session हो;
- target session के अभी खुले अनुरोध, उनके एक-पंक्ति के सार (brief) के रूप में;
- हर नतीजा, सवाल, update, approval notice, टाइप किया गया text, ऐसे turn का जवाब जो voice अनुरोध नहीं
  था, नए अनुरोध से हटाया गया voice जवाब और mod का note, अधिकतम 2,000 अक्षरों की एक पंक्ति के रूप
  में, code blocks और tables हटाकर (टाइप किया गया text जो सिर्फ़ code या table है, उसकी जगह यह बताने
  वाला वाक्य रखा जाता है कि code टाइप किया गया)। mod के notes अनुमति दिए गए या निपटे हुए permission
  prompt के tool का नाम बताते हैं, और बताते हैं कि कोई सवाल बंद हुआ या कोई turn बिना जवाब के ख़त्म
  हुआ। Turn के बीच Claude का पूछा सवाल, और Claude के main loop (subagent नहीं) की permission prompt
  का approval notice, वह text भी साथ लाते हैं जो Claude ने पूछने से ठीक पहले लिखा। Update, Claude का
  जवाब है जो किसी background task के notification से शुरू हुए बाद के turn में आता है, voice अनुरोध
  के बाद 10 मिनट तक और तब तक जब तक session में कोई दूसरा turn शुरू न हो;
- target session का context सारांश, अधिकतम 1,500 अक्षरों की एक पंक्ति के रूप में। यह load होने पर सेव
  होता है और जब भी line खुलती है और वह session target होता है, तब भेजा जाता है, Stop और Start के
  पार और app के restart के बाद भी। Menu का Conversation submenu उस पंक्ति को ठीक वैसी ही दिखाता है
  जैसी वह भेजी जाती है;
- ऊपर की हर पंक्ति के साथ, उसके session का label: Claude Code session का title (80 अक्षरों तक), या
  अगर title न हो तो session folder का नाम। label redact नहीं होता और pause उसे नहीं छूता, इसलिए
  paused text से लिखा गया title हर पंक्ति के साथ जाता है;
- WebRTC offer, जो Mac के local network addresses को connection candidates के रूप में सूचीबद्ध करता है।

**Connect over TCP** चालू होने पर audio अब भी OpenAI के media server पर जाता है, और UDP के बजाय TCP
(देखे गए answers में port 443) से जा सकता है।

नतीजे, सवाल, updates, सारांश और टाइप किए गए turns की पंक्तियाँ पहले जानी-पहचानी credential आकृतियों (private keys, JWTs, आम API
tokens, URL में passwords, `password=` जैसे fields) के redactor से गुज़रते हैं। यह patterns की सूची है,
कोई गारंटी नहीं: आप जो और टाइप करते हैं वह जैसा है वैसा ही जाता है।

voice को ले जाने वाला codex thread अस्थायी (ephemeral) और read-only है, जिसमें हर codex feature बंद है
सिवाय उनके जहाँ वह आपका login रखता है और जहाँ वह आपके proxy का उपयोग करता है, और हर MCP server बंद
है; वह सिर्फ़ बात करने के लिए है। Claude का काम Anthropic को वैसे ही जाता है जैसे आपका Claude Code
session हमेशा भेजता है।

Menu खोलने पर LiveBridge एक अल्पकालिक codex शुरू करता है, जो आपके ChatGPT login से OpenAI से पूछता है कि
आपका Codex usage कितना इस्तेमाल हो चुका है (हर window का प्रतिशत और reset का समय)। यह अधिकतम मिनट में एक
बार होता है, call बंद होने पर भी, और इसमें कोई audio या text नहीं भेजा जाता। Claude के आँकड़े mod से socket
के ज़रिए app तक पहुँचते हैं और कहीं और नहीं जाते; app दोनों को सिर्फ़ memory में रखता है।

Updates के लिए app GitHub से बात करता है। **Check for updates automatically** चालू होने पर, दिन में
एक बार (और हर launch पर, जब तक उसके बताए release को install न किया गया हो) वह बिना credentials के
GitHub के API से पूछता है कि नवीनतम release कौन-सा है; GitHub आपके Mac का IP address देखता है।
Settings का **Check for update** दबाने पर वही request जाता है। अपने-आप होने वाली जाँच में नया
release मिलने पर app `gh auth status` चलाता है, यह बताने के लिए कि image जाँची जा सकती है या नहीं।
सिर्फ़ जब आप **Install** click करते हैं, तभी वह image download करता है और `gh attestation verify` व
`claude plugin` चलाता है, जो आपके अपने logins से GitHub तक, और `gh` के trust root के लिए Sigstore
तक, पहुँचते हैं। [SECURITY.md](../../SECURITY.md#what-leaves-the-mac) में हर request की सूची है।

आपके Mac पर app अपनी settings, usage meter, update की पिछली जाँच का समय और जिन versions की सूचना दी
गई, पिछले update ने क्या किया, और, सबसे हाल में इस्तेमाल हुए 20 sessions में से हर एक की, उसकी हाल
की conversation (64 पंक्तियों तक, जिसमें आपका उसमें टाइप किया हुआ भी है; call के बिना दर्ज होती है,
जब तक आप **Pause sync** चालू न करें) और उससे आख़िरी बार load की गई context पंक्ति `~/Library/Application Support/LiveBridge` में रखता है, ऐसे folder में जिसे केवल आपका user खोल सकता है
([यह कैसे रखी जाती है](../../SECURITY.md#residual-risk-by-design))। किसी session की पंक्तियाँ तब जाती हैं जब आप
उसे target रखकर **New conversation** दबाते हैं या उसे × से हटाते हैं। जो session चला गया है, उसकी
पंक्तियाँ तब तक रहती हैं जब तक उसके बाद इस्तेमाल हुए 20 sessions उन्हें बाहर न धकेल दें; उन्हें
जल्दी मिटाने के लिए, उसी session में फिर से `/live` चलाएँ और **New conversation** दबाएँ।
Uninstall करने से वे सब हट जाती हैं; menu का Uninstall LiveBridge उन्हें Trash में ले जाता
है, और Trash खाली करने पर वे चली जाती हैं। mod Claude Code के plugin store में अपना एक snapshot रखता है ([उसमें क्या है](../../SECURITY.md#residual-risk-by-design))।
**Debug mode**, जो डिफ़ॉल्ट रूप से बंद है, call के दौरान voice के network आँकड़े इसी folder की एक file
में लिखता है, और कुछ नहीं ([सेटिंग्स](guide.hi.md#सेटिंग्स))।
