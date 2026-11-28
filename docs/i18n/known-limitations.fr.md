# Limitations connues

*Le texte anglais fait foi ([known-limitations.md](../known-limitations.md)) ; cette traduction peut être en retard.*

Ce que LiveBridge ne fait pas, ou seulement en partie, avec l'enregistrement derrière chaque point
mesuré. Le [README](README.fr.md#limitations-connues) donne le résumé, et [guide.fr.md](guide.fr.md)
les réglages nommés ici.

- **Connect over TCP** préfère TCP sans l'imposer, et rien ne montre pendant l'appel quel transport une
  ligne a pris : une ligne revenue à UDP peut encore se hacher. La route a été mesurée une fois,
  dans une version de débogage qui retirait les candidats UDP (aucun son perdu en 10 minutes) ; la
  méthode livrée, baisser leur priorité, a choisi TCP une fois. Le mode débogage enregistre le
  transport (`onTcp`) ([CONTRIBUTING.md](../../CONTRIBUTING.md#reading-debug-modes-numbers)).
- La voix dit parfois qu'elle regarde (« On it », « Looking now ») sans transmettre la demande, si
  bien que rien n'arrive à Claude : environ une demande sur cinq avec la règle telle qu'écrite au
  départ, et 0 sur 20 avec la règle actuelle, trop peu pour distinguer cela du hasard
  ([BR-001](../../docs/bugs/BR-001.md)). Elle peut aussi prétendre à un travail qu'elle n'a pas fait,
  comme « I'll take a look. », y compris à partir de lignes qu'elle n'a que comme contexte ([ADR
  0001 (n), (o)](../../docs/adr/0001-platform-findings.md)). L'application joue un son bref quand elle met
  une demande en file pour Claude, différent de celui d'une réponse ; si la voix dit qu'elle regarde
  et que ce son ne suit pas, répétez la demande. L'application ne peut pas distinguer une telle promesse d'une réponse par ses mots,
  car la voix parle votre langue.
- Une question de Claude, ou une demande de permission qu'il attend, est seulement donnée à la voix,
  et la voix peut ne pas la dire ; rien ne l'y oblige. Ne comptez donc pas sur la voix pour annoncer
  une demande de permission quand vous êtes loin du Mac : Claude peut attendre sans que rien ne
  l'annonce. Cette demande attend toujours dans Claude Code, et c'est le seul contrôle ; la voix
  n'est pas un contrôle, et LiveBridge ne répond jamais à la demande. Lors des vérifications, l'avis
  de permission d'un tour tapé, ligne ouverte, a été dit avant la réponse au clavier dans 0 essai
  sur 3, un compte et non un taux ([ADR 0001 (n)](../../docs/adr/0001-platform-findings.md)). Une ligne
  fermée ne s'ouvre pour elles que si la conversation de la cible contient un tour de vous ; sinon
  l'application joue un carillon, et appel éteint elles ne sont qu'enregistrées.
- Un résultat qui arrive pendant que la ligne l'attend est transmis à la voix sous forme de texte à
  dire ; codex n'a aucun appel qui fasse parler la voix immédiatement, c'est donc le modèle qui
  décide du moment. Le test de bout en bout ([scripts/smoke.sh](../../scripts/smoke.sh)) vérifie que
  la voix dit un tel résultat avant vos prochains mots ; le temps qu'elle met à parler n'a pas été
  mesuré. Si ce n'est pas le cas, le
  résultat reste non entendu : il repasse à la voix avec vos prochains mots, ou un carillon retentit
  à la fermeture de la ligne.
- Quand la réponse de Claude rouvre la ligne, la voix peut rester muette : c'est arrivé dans 4 des
  14 essais mesurés, un petit échantillon ([ADR 0001 (n)](../../docs/adr/0001-platform-findings.md)). La
  ligne se ferme alors dès que finit son attente d'un premier mot ([Settings](guide.fr.md#réglages)), et la
  réponse joue un carillon et attend, comme ci-dessous. Quand la voix a parlé, elle a commencé dans
  les 2 secondes environ après la connexion ; une voix qui commencerait après cette attente est
  coupée.
- Quand vos prochains mots rouvrent la ligne, la voix répond parfois uniquement à ceux-ci sans
  dire le résultat en attente. Le résultat n'est pas perdu : il reste en attente, déclenche un
  carillon et publie une notification à la fermeture de la ligne, et il est de nouveau transmis à
  la voix à la prochaine ouverture de la ligne.
- À la limite d'utilisation de votre offre ChatGPT, la voix s'arrête jusqu'à ce que la limite se
  réinitialise. Le menu et la bande le disent, dans la phrase de codex avec son heure de
  réinitialisation quand codex la donne, et l'appel se termine, pour que la parole n'ouvre pas de
  lignes qui échouent. Claude Code continue de travailler, les réponses continuent d'attendre, et
  Start réessaie une fois. L'application ne reconnaît une limite qu'à la formulation de codex ou au
  code d'erreur du service, car rien d'autre ne la signale
  ([détails](../../docs/research/2026-11-05-gpt-live-limits.md)). Un refus qu'elle ne reconnaît pas, comme
  une ligne qui tombe sans raison donnée (« The voice session closed (transport_closed). »), laisse
  l'appel actif, et vos prochains mots réessaient ; appuyez sur **Stop** jusqu'à la réinitialisation
  de la limite.
- Un prompt qui n'est pas tapé dans le compositeur (le message d'un hôte, une tâche planifiée, un
  autre agent et sans doute Remote Control) n'est pas enregistré dans la conversation de la voix
  comme vos mots, mais la réponse de Claude l'est, et il ne refuse pas un tour en cours sous la
  pause ([SECURITY.md](../../SECURITY.md#what-session-text-can-do) dit quels prompts comptent comme les
  vôtres).
- Là où le fournisseur de Claude Code (Bedrock, Vertex ou Foundry) ne propose pas le modèle choisi
  dans **Summary model**, ou où l'organisation ne l'autorise pas, ce modèle échoue et Haiku 5.5
  écrit le résumé ; là où Haiku 5.5 n'est pas proposé non plus, la voix n'a pas de résumé, ce que
  Settings indique. Avant ce réglage, le modèle de la session l'écrivait, ce qui marche partout où
  la session marche. Qu'un id fixé soit résolu chez ces fournisseurs vient de la documentation de
  Claude Code et n'a pas été essayé.
- Une session encore sur un mod antérieur à cette version, jusqu'à son redémarrage, n'est pas
  synchronisée : elle charge un résumé comme une session à laquelle il manque des tours, et aucune
  pause ne refuse ses lignes ([ce qui change d'autre](../../CHANGELOG.md)).
- Une session Claude Code déjà ouverte avant le chargement du mod peut devoir être rouverte pour
  que `/live` y fonctionne.
- Dans l'application de bureau Claude, `/live` saisi dans une session dont le processus Claude
  Code n'a pas encore démarré (une nouvelle session, ou une session à peine rouverte) peut
  afficher « /live isn't a command here. ». La commande s'exécute quand même. L'application de
  bureau établit la liste des commandes d'une telle session à partir d'une vérification qu'elle
  lance avec les hooks désactivés, donc le code du mod, qui déclare `/live`, ne s'y exécute pas ;
  une fois la session lancée, l'application de bureau prend sa liste dans la session elle-même. Le
  mod n'a pas de correctif : un fichier de commande statique serait listé comme
  `/livebridge:live` et non `/live`, et, hooks désactivés, il enverrait son texte au modèle au
  lieu d'exécuter le mod.
- Le fait qu'une réponse ait dit un résultat en attente est jugé d'après ses mots, avec une liste
  de mots courants en anglais et en russe seulement
  ([la règle](../../docs/architecture/overview.md#a-result-while-the-line-is-closed)). Dans une autre
  langue, un résultat peut compter comme entendu alors que la voix l'a seulement mentionné.
- Là où une organisation administre Claude Code, rien dans LiveBridge ne vous signale qu'une
  demande de permission attend. Le garde intégré de Claude Code se charge sur une machine dotée de
  réglages gérés et dans une session connectée à une offre Team ou Enterprise, et là, les hooks de
  permission du mod ne s'exécutent pas. La demande apparaît toujours dans Claude Code et vous
  attend toujours, mais la voix n'en dit rien et le menu montre Claude au travail :
  regardez donc Claude Code si une réponse semble tarder. `/plugin` nomme les hooks, et les
  versions récentes de Claude Code affichent aussi une ligne indiquant qu'un hook a été ignoré.
  Les questions de Claude parviennent toujours à la voix. Les hooks ont été
  [mesurés](../../docs/adr/0001-platform-findings.md) dans un conteneur Linux ; ce que font la voix et
  la barre de menus découle du code, et aucune vraie ligne n'a été testée. Le cas Team et
  Enterprise vient de la documentation de Claude Code.
- Avec `allowManagedHooksOnly`, `allowManagedModsOnly` ou `disableAllHooks` dans les réglages
  gérés, le mod ne se charge pas et `/live` ne fonctionne pas. Un administrateur peut [installer
  le mod comme celui de
  l'organisation](https://code.claude.com/docs/en/plugins/mods/admin#install-your-organizations-mods),
  depuis un dossier sur chaque machine : les hooks de permission s'exécutent alors, y compris avec
  les deux premiers réglages ([mesuré](../../docs/adr/0001-platform-findings.md)). D'après la
  documentation de Claude Code, activer la copie de la marketplace dans les réglages gérés ne
  suffit pas.
