# Utiliser LiveBridge

*Le texte anglais fait foi ([guide.md](../guide.md)) ; cette traduction peut être en retard.*

Chaque commande, la bande, le menu et chaque réglage ; ce que fait la voix ; comment la ligne est
facturée ; et comment mettre à jour et désinstaller. Le [README](README.fr.md) donne le résumé, les
prérequis et l'installation ; [privacy.fr.md](privacy.fr.md), ce qui quitte votre Mac ; et
[known-limitations.fr.md](known-limitations.fr.md), ce qui ne fonctionne pas encore.

## Utilisation

### Commandes

Dans la session Claude Code à laquelle vous voulez parler :

| Commande | Ce qu'elle fait |
|---|---|
| `/live` | Rejoint LiveBridge sous le titre de la session, et ouvre l'application si elle n'est pas lancée. Dans une session déjà rejointe, fait revenir la bande et répond en une ligne : l'appel, la cible, les résultats non entendus, les minutes du jour. |
| `/live off` | Quitte LiveBridge. |

La commande est `/live`, et non `/voice`, car `/voice` est le mode vocal propre à Claude Code.
Garder ou non hors de la voix ce que vous tapez dans une session tant que l'appel est arrêté n'est
pas une commande : c'est un réglage unique pour toutes les sessions, dans la fenêtre
[Settings](#réglages) de LiveBridge.

### La bande et le menu

Appuyez sur **Start**, dans la bande au-dessus du prompt ou dans le menu de la barre des menus, et
parlez.

- **Le Start de la bande** fait de sa session la cible et démarre l'appel ; la ligne qu'il ouvre
  reçoit la conversation de la session, et charge en plus un résumé quand il manquerait à la voix
  une partie d'elle (voir **Load context** ci-dessous), mais avec **Pause sync** activé ou
  après une pause seulement si elle n'en a pas encore ([détails](../../docs/architecture/overview.md#when-the-app-asks)). Avec un mod de cette version, le
  résumé est demandé au Start et au changement de cible pendant l'appel, et la ligne l'attend avant
  de se connecter, au plus [la limite de l'attente](../../docs/architecture/overview.md#its-time) : ce que vous dites entre-temps est gardé
  sur le Mac et joué à la voix quand la ligne s'ouvre. Stop ou un changement de cible pendant
  l'attente jette ce qui était gardé, de même qu'une reconnexion après un changement de **Connect
  over TCP**, qui garde au plus les 2 dernières secondes pour la ligne rouverte. Tant que l'appel parle à
  une autre session, la bande affiche **Talk here**. Si la bande n'apparaît pas dans une session
  rejointe, `/live` la fait revenir.
- **Le menu de la barre des menus** contient l'appel, les sessions rejointes (cliquez sur l'une
  pour en faire la cible), **Load context**, la **Conversation** de la cible telle que LiveBridge
  la conserve (avec une ligne **Task** pour chaque demande que la voix a transmise à Claude et une ligne **Loaded context** là où un résumé a été chargé), les
  limites d'utilisation, les minutes, **Quick Settings** (des éléments à coche pour
  **Connect over TCP**, **Play sounds for requests and answers**, **Notify when a result is waiting**, **Pause sync while the call is stopped** et **Load a session's context on its first call**),
  **Settings…**, **Feedback & Support** (**Report a Bug…** ouvre le formulaire de rapport de bogue
  du dépôt, **LiveBridge Website** ouvre getlivebridge.com, **Star LiveBridge on GitHub** ouvre la
  page du dépôt, puis **Debug Mode** et **Show Debug Files**, l'interrupteur et le dossier du
  [mode débogage](#réglages), et **Uninstall LiveBridge…** ([Désinstallation](#désinstallation))) et **Quit LiveBridge**. Quick Settings est là même quand le menu ne montre que
  l'appel. Pendant un appel, **Conversation** affiche vos mots et ceux de la voix à mesure
  que codex les transcrit : les vôtres peuvent donc apparaître un instant après que vous les avez dits,
  et ceux de la voix un instant avant que vous les entendiez. Quand chaque phrase est terminée, son
  texte final les remplace. Seul le texte final est conservé : les mots qui l'attendent encore quand la
  ligne se ferme sont perdus.
- **Mute** (à côté de **Stop**, dans la bande et dans la carte d'appel du menu ; **Unmute** quand le
  micro est coupé) libère votre microphone pendant que l'appel continue : une réponse de Claude
  ouvre toujours la ligne et passe à la voix pour qu'elle la dise. Micro coupé, la
  voix ne transmet rien à une session : vous n'avez pas pu le demander, donc une telle transmission
  est la voix qui agit sur les lignes qu'elle a reçues, et l'app lui dit que rien n'a été transmis.
  Répétez-le après **Unmute**. La bande garde la phase et ajoute
  `· muted` ; le menu affiche « Muted — line closed » tant qu'aucune ligne n'est ouverte. Mute ne
  ferme pas la ligne : une ligne ouverte se ferme après le silence habituel, compté à partir de Mute
  si vous parliez, et quand elle l'aurait fait sans Mute si la ligne était déjà silencieuse ; elle
  est facturée comme n'importe quel silence, donc Mute n'économise pas de minutes temps réel.
  **Unmute** reprend le microphone et, s'il n'y parvient pas (refusé, occupé, absent), l'appel se
  termine avec la raison. **Stop** termine l'appel et la coupure ; le **Start** suivant commence
  micro actif. Mute n'est pas un verrou : tout processus qui s'exécute sous votre compte peut le
  lever ([SECURITY.md](../../SECURITY.md#who-can-drive-the-bridge)).
- **Load context** n'est activé que lorsqu'il manque à la voix une partie de la cible : pas de
  résumé et **Pause sync** empêche la ligne suivante d'en charger un ou le dernier demandé a échoué (jusqu'au prochain tour de la session ou au prochain Start), un tour non arrivé, une question ou un avis de permission non parvenu à l'application, des
  tours passés mod éteint, des lignes depuis le résumé qui ne tiennent plus toutes dans ce que la
  voix peut porter (une longue conversation le dépasse), la session a été mise en pause et a un résumé, ou son mod
  ne synchronise pas. Sinon l'élément affiche **Context up to date** et est désactivé, car la voix a
  déjà la conversation. Sans ligne ouverte, quand la ligne suivante va charger le résumé et que rien d'autre ne manque, il affiche **Context loads with the
  line** et est désactivé, car la prochaine ligne le demande d'elle-même. Tant qu'un résumé de la
  cible est en route, quoi qui l'ait demandé, il affiche **Loading context…** et est désactivé, au plus le temps que le mod lui accorde ([combien](../../docs/architecture/overview.md#its-time) ; avec un mod plus ancien, il reste sur **Load context**) ; un
  résumé qui arrive affiche **Context loaded** un instant, et une réponse vide revient à **Load
  context**. Un résumé ne porte pas de date : il peut être ignoré alors que l'élément
  reste activé ([BR-002](../../docs/bugs/BR-002.md)).
- **New conversation…** efface la conversation de la cible et son contexte chargé, et le × d'une
  session la retire et efface sa propre conversation ; les deux demandent confirmation. La voix
  repart de zéro à la prochaine ouverture de la ligne. Les résultats qu'elle n'a pas encore dits
  restent et sont ajoutés de nouveau ; seul **Stop** les efface. Les questions de Claude en attente
  suivent d'autres règles ([détails](../../SECURITY.md#residual-risk-by-design)). Avec **Load a session's context on its first call** activé, ou avec **Pause sync**
  désactivé et la session sans pause, la ligne suivante charge d'elle-même un résumé de la même
  transcription de la session, qui contient le texte de la conversation (une app et un mod de cette
  version en retirent la sortie des outils, le raisonnement et les rappels, mais pas le texte qui
  les cite, et une version antérieure envoie toute la requête) ; pour l'éviter, faites d'abord
  `/clear` dans la session, puis appuyez sur **New conversation**. `/live` dans une session
  retirée la rejoint de nouveau.

### Réglages

**Settings…** ouvre la fenêtre Settings de LiveBridge, en quatre onglets dans sa barre d'outils.
**Quick Settings**, dans le menu, reprend cinq de ses interrupteurs ([le menu](#la-bande-et-le-menu)) :
chaque élément est le réglage lui-même, donc un changement à un endroit se voit aussitôt à l'autre,
et il demande ce que demande l'interrupteur d'ici.
**General** regroupe les notifications, l'ouverture à la connexion, les mises à jour et le mode
débogage :

- **Notify when a result is waiting** (activé par défaut) : avec le carillon pour un résultat qui
  attend pendant que la ligne est fermée, une notification macOS nomme la session (« Alpha has a
  new result — speak to hear it »), jamais le résultat lui-même. Cliquer dessus ouvre le menu de
  la barre des menus.
- **Open at login** (désactivé par défaut).
- **Updates** : la version en cours, **Check for update**, **Check for updates automatically** et
  ce qu'a fait la dernière mise à jour ([Mises à jour](#mises-à-jour)).
- **Debug mode** (désactivé par défaut) : pendant un appel, une ligne par seconde des chiffres
  réseau de la voix (paquets perdus et écartés, gigue, échantillons masqués, si la ligne passe par
  TCP), un CSV par appel, dans `~/Library/Application Support/LiveBridge/debug/call-stats/` ; ni
  audio, ni transcription, ni noms de session. Activé pendant un appel, il enregistre la ligne
  ouverte à partir de ce moment ; désactivé, il s'arrête aussitôt, et les fichiers restent jusqu'à
  ce que vous les supprimiez. **Show Debug Files** ouvre le dossier. Dans le menu, c'est **Debug
  Mode**, dans **Feedback & Support**
  ([lire les chiffres](../../CONTRIBUTING.md#reading-debug-modes-numbers)).

**Voice** regroupe ce que vous entendez pendant un appel :

- **Voice** : l'une des voix temps réel proposées par votre codex, que codex liste à l'ouverture
  de cet onglet, ou **Codex default**. Elle s'entend dès la prochaine ouverture de la ligne.
- **Prompt** (vide par défaut) : vos propres instructions pour la voix, par exemple « Parle-moi
  en espagnol », jusqu'à 2 000 caractères. Elles sont ajoutées après les règles propres de
  LiveBridge pour la voix, qui l'emportent en cas de désaccord, et s'appliquent dès la prochaine
  ouverture de la ligne.
- **Play sounds for requests and answers** (activé par défaut) : un son bref pour chaque demande que la
  voix transmet à Claude ([pourquoi](known-limitations.fr.md)) et pour chaque réponse, échec ou
  question de Claude qui arrive sur une ligne ouverte ou en cours d'ouverture quand personne ne
  parle. Le signal d'un résultat en attente retentit dans tous les cas.

**Line** regroupe combien de temps la ligne reste ouverte dans le silence et comment elle
se connecte :

- **Silence before the line closes** (20 secondes par défaut), **Wait for a first word on a line
  a result opened** (10 secondes) et **Sound without words before the line closes** (90 secondes) :
  combien de temps chaque sorte de silence garde une ligne ouverte, de 0 à 300 secondes. 0 désactive
  le silence ou le son sans paroles, et une attente du premier mot à 0 attend aussi longtemps que le
  silence. Avec les trois à 0, le silence ne ferme jamais la ligne : elle reste ouverte, facturée
  tout ce temps ([Facturation](#facturation-maîtrisée-par-conception)), jusqu'à ce que vous appuyiez
  sur Stop, changiez de cible ou qu'OpenAI la ferme. Un silence court ferme la ligne au milieu de
  pauses ordinaires, et chaque réouverture prend quelques secondes avant que la voix réponde, donc
  Settings avertit de 1 à 9 secondes ; il fait de même pour le son sans paroles, car votre parole
  compte comme tel tant qu'elle n'est pas reconnue, et de 1 à 3 secondes pour le premier mot, car la
  voix commence souvent environ 2 secondes après la connexion de la ligne. Un minuteur que vous
  activez démarre aussitôt sur une ligne ouverte et silencieuse ; celui qui compte déjà garde son
  temps.
- **Connect over TCP** (désactivé par défaut) : si la voix se hache sur une mauvaise connexion,
  activez-le. La ligne préfère alors la route TCP que propose le serveur média (le port 443 dans
  les réponses observées) à UDP, et peut encore revenir à UDP. Sur une connexion qui perd des
  paquets, cela peut changer les coupures en courtes pauses entre les phrases ([jusqu'où c'est
  testé](known-limitations.fr.md)). Une ligne ouverte au moment du changement se ferme et se rouvre
  aussitôt, après votre confirmation ; ce que la voix disait est coupé, et un résultat que la ligne
  attendait arrive quand même sur la nouvelle.

**Context** regroupe comment vos sessions parviennent à la voix :

- **Pause sync while the call is stopped** (désactivé par défaut) : par défaut, ce que vous tapez
  dans une session rejointe et la réponse finale de Claude sont gardés dans la conversation de cette
  session avec la voix même quand l'appel est arrêté, et la voix les a quand la ligne suivante
  s'ouvre. Rien de tout cela n'arrive chez OpenAI avant l'ouverture d'une ligne. Pour un texte que vous ne voulez pas
  voir arriver chez OpenAI, activez le réglage, désactivez le suivant si la session n'a peut-être pas encore de résumé, appuyez sur Stop, puis tapez : rien de ce que vous
  tapez appel arrêté n'est enregistré, et la session est marquée en pause. Tant qu'il est activé,
  aucune ligne ne charge de résumé d'elle-même, ni après une pause, sauf pour une session sans résumé (le réglage suivant) ; sinon seul
  **Load context** le fait. Ce résumé est écrit à partir de la transcription, donc il porte ce
  que vous avez mis en pause. Taper dans un tour qui exécute une demande vocale fait échouer sa
  réponse, sans que rien en soit enregistré ni dit. Le réglage ne supprime rien de ce qui est déjà
  enregistré, et les réponses ultérieures de Claude peuvent répéter le texte mis en pause ; ce qu'il
  fait et ne fait pas est dans [SECURITY.md](../../SECURITY.md#residual-risk-by-design).
- **Load a session's context on its first call** (activé par défaut ; désactivé si **Pause sync** était activé lors de la mise à jour) :
  Start, un changement de cible pendant l'appel ou une ligne qui s'ouvre, pour une session dont la
  voix n'a pas de résumé, en demande un même si **Pause sync** est activé ou si la session est en pause, y compris pour une ancienne discussion
  ou après **New conversation**. Ce résumé est écrit à partir de la transcription, donc il porte ce
  que vous avez mis en pause, et il part chez OpenAI. Une fois qu'une session a un résumé,
  la pause régit ce qui suit. Désactivé, sous la pause seul **Load context** charge un résumé.
- **Summary model** (Haiku 5.5 par défaut, après une mise à jour aussi ; ou Sonnet 5.5,
  Opus 5.5 ou **Custom…**) : le modèle qui écrit le résumé que la voix reçoit comme contexte, toujours avec un
  effort faible, sur votre usage de Claude. Si un autre modèle échoue, Haiku 5.5 l'écrit à sa place, sauf si ce modèle a manqué de temps.
  Une ligne en dessous dit quand le dernier résumé est venu de Haiku 5.5, ou d'aucun modèle, et
  pourquoi. Une session sur un mod antérieur à ce réglage l'ignore et écrit avec le modèle de la
  session. **Custom…** prend un id de modèle et **Check and save**, qui fait envoyer par une session
  jointe une requête courte à ce modèle (« Reply with OK. »), sur votre usage de Claude, et n'enregistre
  l'id que s'il répond ; sinon la raison s'affiche à côté du champ et le choix précédent reste. Il
  faut une session sur un mod de cette version, et le résultat vaut pour le Claude Code de cette
  session : une autre session peut différer, et un id enregistré n'est plus vérifié.

### Ce que fait la voix

- Elle répond elle-même aux bavardages et aux explications, et transmet tout ce qui requiert le
  dépôt ou la session : tâches, questions sur le code, décisions, corrections et arrêts.
- Avant de transmettre quoi que ce soit de destructeur ou tourné vers l'extérieur (supprimer,
  pousser, publier, envoyer, déployer, payer), elle répète la demande et demande « oui ? ». C'est
  une habitude que la voix a pour consigne de garder, pas une garantie de sécurité ;
  [SECURITY.md](../../SECURITY.md) explique ce qui en est une.
- Elle relit les résultats en une phrase ou deux, avec le nom de la session. Les blocs de code et
  les tableaux restent dans la session, et les identifiants qu'elle reconnaît sont masqués.
- Elle revient quand Claude a fini. Inutile de garder la ligne ouverte : elle se ferme quand la
  conversation retombe, et la réponse de Claude à votre demande la rouvre et est donnée à la voix
  pour qu'elle la dise, vous pouvez donc vous éloigner pendant que Claude travaille. Cela vaut pour
  la session à laquelle vous parlez ; un résultat d'une autre session joue un carillon et attend
  ([comment c'est facturé](#facturation-maîtrisée-par-conception)). Si la voix reste muette sur la
  ligne rouverte, la réponse joue aussi un carillon et attend, elle n'est donc pas perdue. Une
  question que Claude vous pose ou une demande de permission qu'il attend ouvre la ligne de la même
  façon, mais la voix peut ne pas la dire : n'y comptez pas quand vous êtes loin du Mac
  ([limitations connues](known-limitations.fr.md)).
- Quand Claude pose une question, elle est donnée à la voix pour qu'elle vous la pose, et votre
  réponse repart vers cette session. Il en va de même d'une question que Claude pose pendant qu'il
  travaille (la boîte de dialogue à options) : la voix la reçoit pour vous en parler, expliquer les
  options avec ses propres mots et en discuter avec vous aussi longtemps que vous voulez, sans
  interroger Claude. Ce que vous décidez, une option ou une question en retour à Claude, répond à la
  boîte de dialogue ; vous pouvez toujours y répondre au clavier. Le travail que Claude termine plus
  tard en arrière-plan passe à la voix comme une mise à jour.
- Quand Claude attend une demande de permission, la voix reçoit un avis et peut le dire, sauf [là où
  une organisation administre Claude Code](known-limitations.fr.md). Vous répondez à la demande dans
  Claude Code ; LiveBridge n'y répond jamais à votre place.
- Elle reçoit ce que vous tapez. Tant qu'une session est rejointe, ce que vous y tapez et la réponse
  finale de Claude à chaque tour qui n'était pas une demande vocale vont dans la conversation de
  cette session avec la voix, comme contexte : ils ne font pas sonner de carillon et n'ouvrent pas
  une ligne fermée ([les limites de ceci](known-limitations.fr.md)). Une ligne ouverte les reçoit
  aussitôt ; une ligne ouverte plus tard en est alimentée. Une réponse vocale qu'une demande plus
  récente a supplantée n'est pas dite, mais elle est gardée et ajoutée de la même façon. Le texte de
  Claude en milieu de tour n'est pas synchronisé, sauf ce qu'il a écrit juste avant une question ou
  une demande de permission, qui l'accompagne ; les sous-agents et la sortie des outils ne le sont
  pas non plus. Une question ou une demande de permission dans la cible est donnée à la voix, quel
  que soit le tour qui l'a provoquée ; dans une autre session, elle va comme irait un résultat venu
  d'elle, sauf que celle d'un tour qui n'était pas une demande vocale n'est qu'enregistrée. Un tour
  que la pause tient dehors n'a rien de tout cela. Quand une question ou une demande est réglée sans
  la voix, ou qu'un tour se termine sans réponse, la voix reçoit une ligne qui le dit ([quelles
  lignes](../../SECURITY.md#what-session-text-can-do)).

## Facturation maîtrisée par conception

Une session vocale en temps réel coûte tant qu'elle est ouverte, donc LiveBridge ne l'ouvre que
pendant que quelqu'un parle, pendant que la réponse de Claude à une demande que vous venez de
faire peut encore arriver, ou pour dire cette réponse, une question de Claude ou que Claude
attend votre autorisation :

- Tant qu'un appel est en cours et que personne ne parle, le microphone alimente uniquement un
  détecteur de voix sur votre Mac. Aucun audio n'est envoyé nulle part.
  Tant que Mute est actif, LiveBridge ne détient aucun microphone, et l'indicateur de microphone de macOS le montre.
- Quand vous commencez à parler, la ligne s'ouvre. Les 2 secondes précédant votre prise de parole
  sont conservées et envoyées en premier, afin que vos premiers mots ne soient pas perdus.
- La ligne se ferme après un temps de silence, et un son sans paroles (musique, télévision) la
  ferme après un temps qui lui est propre. [Settings](#réglages) règle chacun ; à 0, celui-là ne la
  ferme pas.
- Quand la voix transmet une demande à Claude (un transfert), la ligne reste ouverte jusqu'à 2
  minutes après ce transfert, facturée comme n'importe quelle ligne ouverte, et la réponse de Claude
  passe à la voix pour qu'elle la dise dès que plus personne ne parle. Un transfert ultérieur
  relance les 2 minutes ; un échange qui n'envoie rien à Claude se ferme après le silence habituel.
- La réponse de Claude à une demande confiée à la session à laquelle vous parlez, une question que
  Claude vous y pose ou une demande d'autorisation qu'il attend rouvre la ligne si elle arrive alors
  que la ligne est fermée, et elle est donnée à la voix pour qu'elle la dise, facturée comme toute
  ligne ouverte. Tout le reste de ce qui arrive ligne fermée (tout ce qui vient d'une session que
  vous avez quittée, une mise à jour ultérieure) joue un carillon et attend : la bande et le menu
  l'affichent comme non entendu, et il passe à la voix la prochaine fois que vous parlez ([quand il
  compte comme entendu](../../docs/architecture/overview.md#a-result-while-the-line-is-closed)).
- Chaque session Claude Code a sa propre conversation avec la voix. Elle est reportée sur la
  session temps réel suivante, et d'un Stop à un Start, de sorte que la voix se souvient de ce que
  vous avez dit il y a une minute. Une nouvelle cible change de conversation : une ligne ouverte
  se ferme, et vos prochains mots l'ouvrent avec la conversation de la nouvelle cible.
- Le menu affiche les minutes pendant lesquelles la ligne a été ouverte, comptées par l'application
  à partir du moment où la voix se connecte, donc votre offre peut compter un peu plus. OpenAI
  facture la voix sur ordinateur à la minute de votre budget d'usage Codex, et sur son API la même
  famille de modèles facture aussi le silence
  ([détails](../../docs/research/2026-11-04-gpt-live-billing.md),
  [limites](../../docs/research/2026-11-05-gpt-live-limits.md)) ; la page d'usage de votre offre fait
  autorité.
- Le menu indique quelle part de votre usage de Codex et de Claude est consommée, une ligne chacun,
  en pourcentage utilisé de chaque fenêtre que l'offre signale (jusqu'à trois par ligne, par
  exemple `7% of 5 h · 19% of week`), en orange à partir de 90 % ; survolez une ligne pour voir
  quand chaque fenêtre se réinitialise. Les chiffres de Codex sont lus à chaque ouverture du menu,
  au plus une fois par minute, par un codex de courte durée ; ceux de Claude viennent d'une
  session rejointe qui a déjà répondu. Une ligne sans rien à montrer est omise, et celle de Codex
  indique `blocked` quand codex signale que l'usage ordinaire n'est pas autorisé. La dernière lecture
  de Codex s'affiche aussitôt et une nouvelle la remplace quelques secondes plus tard, donc les
  chiffres peuvent changer menu ouvert ; juste après le lancement, la ligne apparaît quand la
  première lecture arrive, et si les lectures échouent, une lecture disparaît au bout de 15 minutes. Quelle limite
  arrête la voix en premier n'est pas documenté
  ([détails](../../docs/research/2026-11-05-gpt-live-limits.md)).

## Mises à jour

LiveBridge met à jour l'application et son mod quand vous cliquez sur **Install**, et jamais de
lui-même. Seule la copie située à `/Applications/LiveBridge.app` se met à jour ; toute autre
copie l'indique dans Settings.

- **Check for updates automatically**, dans Settings (activé par défaut, désactivé pour une
  compilation depuis les sources) : une fois par jour, l'application demande à GitHub quelle est
  la dernière version. Une version plus récente est annoncée une seule fois, par une notification
  dont le bouton **Install** l'installe, et le menu de la barre des menus propose **Install
  LiveBridge X.Y.Z…** jusqu'à son installation, en interrogeant de nouveau GitHub à chaque
  lancement pour conserver cet élément. **Check for update**, dans Settings, interroge GitHub
  tout de suite.
- **Install** a besoin de la [GitHub CLI](https://cli.github.com) connectée (`gh auth login`) ;
  sans elle, Install ne télécharge rien et renvoie à la page de la version. Il télécharge l'image
  de la version, la vérifie avec le même `gh attestation verify` que montre
  [Depuis l'image disque](README.fr.md#depuis-limage-disque), puis vérifie
  l'application qu'elle contient, et n'installe rien si une seule vérification échoue. Il attend
  tant que Claude traite encore une demande vocale, met à jour le mod avec
  `claude plugin marketplace update livebridge` et `claude plugin update livebridge@livebridge`,
  arrête l'appel, met la nouvelle application en place en une seule étape et l'ouvre.
- Ensuite, Settings indique la version d'origine de la mise à jour. Si le mod n'a pas pu être mis
  à jour, il affiche ces deux commandes pour que vous les exécutiez vous-même. Les sessions
  Claude Code déjà ouvertes gardent l'ancien mod jusqu'à leur redémarrage ; Settings liste
  celles qui sont rejointes et l'utilisent encore.
- Le téléchargement de la mise à jour ne pose pas d'attribut de quarantaine, donc macOS ne
  devrait pas interrompre le premier lancement de l'application mise à jour pour demander, comme
  il l'a fait après le premier téléchargement ; cela découle du code et n'a pas encore été
  observé. Les vérifications ci-dessus en tiennent lieu
  ([SECURITY.md](../../SECURITY.md#what-an-update-installs)). Les versions postérieures à 0.4.2
  sont signées avec le Developer ID de LiveBridge, donc l'autorisation du microphone devrait passer d'une
  version à la suivante ; cela découle de la façon dont macOS rattache cette autorisation et n'a
  pas encore été observé. La 0.4.2 et les précédentes étaient signées ad hoc, si bien que la
  première mise à jour depuis l'une d'elles redemande le microphone une fois, au premier
  **Start**.

Pour mettre à jour à la main, exécutez `/live off` dans chaque session (le mod rouvre
l'application de `/Applications` dès qu'elle ne répond plus), quittez LiveBridge, installez
l'image plus récente comme l'indique [Installation](README.fr.md#installation) et exécutez les deux
commandes `claude plugin`.

## Désinstallation

Dans la copie de `/Applications`, **Feedback & Support ▸ Uninstall LiveBridge…**, dans le menu,
demande d'abord, puis met l'app dans la Corbeille ; s'il ne le peut pas, il le dit, laisse
l'app où elle est et remet l'ouverture à la connexion qu'il aurait retirée d'abord, et si macOS ne lui permet pas de la remettre, il le dit aussi, et comment réactiver **Open at login**. Puis l'appel ouvert prend fin et chaque session quitte LiveBridge, comme avec
le × du menu, donc `/live` s'y éteint au lieu de rouvrir LiveBridge ; LiveBridge retire
l'ouverture à la connexion et l'autorisation du micro et quitte, et une fois qu'il a quitté,
les fichiers qu'il garde (ceux ci-dessous) vont dans un dossier de la Corbeille, jusqu'à ce que vous la vidiez. Il laisse le mod Claude Code et copie la commande qui
le retire, `claude plugin uninstall livebridge@livebridge`, pour que vous la lanciez dans
Terminal. Une session qui n'était pas ouverte alors peut chercher LiveBridge à sa réouverture ;
retirer le mod y met fin.

Installé avec Homebrew ? `brew uninstall --cask getlivebridge/tap/livebridge` retire l'app et la trace qu'en garde
Homebrew ; les étapes ci-dessous restent valables pour les fichiers de l'app.

Depuis un clone, `scripts/build-app.sh --uninstall` supprime `/Applications/LiveBridge.app`,
quelle que soit la manière dont il a été installé, son élément d'ouverture de session et tous les
fichiers qu'il conserve, puis affiche les deux commandes qu'il vous laisse exécuter :
`tccutil reset Microphone com.getlivebridge.livebridge` et
`claude plugin uninstall livebridge@livebridge`.

Sans clone, désactivez **Open at login** dans les Settings de LiveBridge, quittez LiveBridge, puis
exécutez les mêmes étapes dans Terminal :

```sh
rm -rf /Applications/LiveBridge.app ~/Library/Application\ Support/LiveBridge \
  ~/Library/{Caches,WebKit}/com.getlivebridge.livebridge \
  ~/Library/HTTPStorages/com.getlivebridge.livebridge{,.binarycookies} \
  ~/Library/Preferences/com.getlivebridge.livebridge.plist
tccutil reset Microphone com.getlivebridge.livebridge
claude plugin uninstall livebridge@livebridge
```

Aucune de ces méthodes ne supprime une copie nommée `/Applications/.LiveBridge-update-….app`,
qu'une mise à jour interrompue en pleine installation peut laisser. L'application supprime ces
copies à son lancement suivant ; après une désinstallation, supprimez-la à la main si elle
existe.

`claude plugin uninstall` peut laisser l'instantané du mod,
`~/.claude/plugins/store/livebridge_*.json` : la documentation de Claude Code sur ce qu'il supprime
ne nomme pas ce fichier, et cela n'a pas été exécuté. Supprimez-le à la main s'il est là.
