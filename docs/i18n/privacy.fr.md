# Confidentialité

*Le texte anglais fait foi ([privacy.md](../privacy.md)) ; cette traduction peut être en retard.*

Ce qui atteint OpenAI et GitHub, et ce que LiveBridge garde sur votre Mac. Le
[README](README.fr.md#confidentialité) donne le résumé, et [SECURITY.md](../../SECURITY.md) le modèle
de menace.

LiveBridge n'a pas de télémétrie et n'écoute sur aucun port réseau ; le mod parle à l'application
par un socket Unix situé dans un dossier que seul votre utilisateur peut ouvrir. Ce qui part vers
OpenAI, via la session temps réel de codex :

- l'audio du microphone tant que la ligne est ouverte, de 2 secondes avant que vous ne commenciez à
  parler (ou, pour une ligne qu'une réponse, une question ou une demande d'autorisation de Claude a
  ouverte, dès son ouverture) jusqu'à sa fermeture (sous Mute, LiveBridge ne capte rien, donc rien
  ne part ; ce que vous avez dit avant d'appuyer sur Mute, sur une ligne qui était déjà en train de
  se connecter, peut quand même partir) ;
- les instructions de la voix : les règles propres de LiveBridge, puis le **Prompt** de vos
  Settings si vous en avez écrit un ;
- la conversation récente de la session cible (jusqu'aux 64 dernières lignes, et pas plus que ce que
  codex accepte : 128 éléments et environ 8 192 jetons avec le contexte et les tâches ouvertes) pour
  la poursuivre dans une nouvelle session temps réel. Elle contient ce que vous avez tapé dans cette
  session et la réponse finale de Claude à chaque tour qui n'était pas une demande vocale, quelle
  qu'en soit l'origine (un tour que vous avez tapé, une tâche planifiée, un autre agent, une tâche
  d'arrière-plan), en plus des notes du mod, de votre voix et de celle de la voix : taper dans une
  session l'envoie donc à OpenAI quand une ligne s'ouvre avec elle. Tant qu'une ligne est ouverte,
  chaque nouvelle ligne de la cible y entre aussitôt. Les lignes synchronisées d'une autre session
  ne partent que lorsqu'une ligne s'ouvre avec elle comme cible ; ses résultats, questions et avis
  d'approbation entrent dans la ligne ouverte, quelle que soit la session ;
- les demandes encore ouvertes de la session cible, sous forme de résumés d'une ligne ;
- chaque résultat, question, mise à jour, avis d'approbation, texte tapé, réponse à un tour qui
  n'était pas une demande vocale, réponse vocale supplantée par une demande plus récente et note du
  mod, en une ligne d'au plus 2 000 caractères, blocs de code et tableaux retirés (un texte tapé qui
  n'est que du code ou un tableau est remplacé par une phrase disant que du code a été tapé). Les
  notes du mod nomment l'outil d'une demande de permission autorisée ou réglée, et disent qu'une
  question a été fermée ou qu'un tour s'est terminé sans réponse. Une question que Claude pose en
  cours de tour, et l'avis d'approbation d'une permission que demande la boucle principale de Claude
  (pas un sous-agent), portent aussi ce que Claude a écrit juste avant de demander. Une mise à jour
  est la réponse de Claude dans un tour ultérieur déclenché par la notification d'une tâche
  d'arrière-plan, pendant au plus 10 minutes après une demande vocale et jusqu'à ce qu'un autre tour
  démarre dans la session ;
- le résumé de contexte de la session cible, en une ligne d'au plus 1 500 caractères. Il est
  enregistré quand il est chargé et envoyé à chaque ouverture de la ligne tant que cette session
  est la cible, d'un Stop à un Start et d'un redémarrage de l'application à l'autre. Le
  sous-menu Conversation du menu affiche cette ligne exactement telle qu'elle est envoyée ;
- avec chacune des lignes ci-dessus, le libellé de sa session : le titre de la session Claude Code
  (jusqu'à 80 caractères), ou le nom du dossier de la session si elle n'en a pas. Le libellé n'est
  pas masqué et la pause n'y touche pas, donc un titre écrit à partir d'un texte mis en pause part
  sur chaque ligne ;
- l'offre WebRTC, qui liste les adresses réseau locales du Mac comme candidats de connexion.

Avec **Connect over TCP** activé, l'audio va toujours au serveur média d'OpenAI, et peut passer par
TCP (le port 443 dans les réponses observées) au lieu d'UDP.

Les résultats, questions, mises à jour, résumés et lignes des tours tapés passent d'abord par un masqueur de formes
connues d'identifiants (clés privées, JWT, jetons d'API courants, mots de passe dans les URL,
champs de type `password=`). C'est une liste de motifs, pas une garantie : tout le reste de ce que vous tapez part tel quel.

Le thread codex qui porte la voix est éphémère et en lecture seule, avec toutes les
fonctionnalités de codex désactivées sauf celles qui conservent votre connexion et gèrent
l'utilisation de votre proxy, et tous les serveurs MCP désactivés ; il ne sert qu'à parler. Le
travail de Claude va vers Anthropic comme le fait toujours votre session Claude Code.

À l'ouverture du menu, LiveBridge lance un codex de courte durée qui demande à OpenAI, avec votre
connexion ChatGPT, quelle part de votre usage de Codex est consommée (le pourcentage et l'heure de
réinitialisation de chaque fenêtre). Cela arrive au plus une fois par minute, aussi quand l'appel
est coupé, et n'envoie ni audio ni texte. Les chiffres de Claude parviennent à l'application
depuis le mod par le socket et ne vont nulle part ailleurs ; l'application garde les deux en
mémoire seulement.

Pour les mises à jour, l'application parle à GitHub. Avec **Check for updates automatically**
activé, une fois par jour (et à chaque lancement tant qu'une version qu'elle a annoncée n'est pas
installée), elle demande à l'API de GitHub, sans identifiants, quelle est la dernière version ;
GitHub voit l'adresse IP de votre Mac. **Check for update**, dans Settings, envoie la même
requête quand vous cliquez dessus. Quand la vérification automatique trouve une version plus
récente, l'application exécute `gh auth status` pour indiquer si l'image peut être vérifiée. Ce
n'est que lorsque vous cliquez sur **Install** qu'elle télécharge l'image et exécute
`gh attestation verify` et `claude plugin`, qui contactent GitHub, et Sigstore pour la racine de
confiance de `gh`, sous vos propres connexions. [SECURITY.md](../../SECURITY.md#what-leaves-the-mac)
liste chaque requête.

Sur votre Mac, l'application conserve ses réglages, le compteur d'utilisation, la date de sa
dernière recherche de mise à jour et les versions qu'elle a annoncées, ce qu'a fait la dernière
mise à jour et, pour chacune des 20 dernières sessions utilisées, sa conversation récente
(jusqu'à 64 lignes, avec ce que vous y avez tapé ; enregistrée sans appel sauf si vous activez
**Pause sync**) et la ligne de contexte chargée en dernier depuis elle, dans `~/Library/Application Support/LiveBridge`, un dossier que seul votre utilisateur peut ouvrir
([comment il est conservé](../../SECURITY.md#residual-risk-by-design)). Les lignes d'une session disparaissent quand vous
appuyez sur **New conversation** avec elle comme cible ou que vous la retirez avec ×. Une session
qui est partie les conserve jusqu'à ce que 20 sessions utilisées ensuite les évincent ; pour les
effacer plus tôt, exécutez de nouveau `/live` dans cette session et appuyez sur **New
conversation**. La désinstallation les supprime toutes ; Uninstall LiveBridge, dans le menu, les met dans la
Corbeille, et elles disparaissent quand vous la videz. Le mod garde un instantané à lui dans le magasin de plugins de Claude Code ([ce qu'il contient](../../SECURITY.md#residual-risk-by-design)).
**Debug mode**, désactivé par défaut, écrit les chiffres réseau de la voix pendant un appel dans un
fichier de ce dossier, et rien de plus ([Réglages](guide.fr.md#réglages)).
