<p align="center"><a href="../../README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.hi.md">हिन्दी</a> · <a href="README.es.md">Español</a> · <b>Français</b> · <a href="README.ru.md">Русский</a> · <a href="README.uk.md">Українська</a></p>

<p align="center"><img src="../../site/assets/icon.png" alt="Icône de l'application LiveBridge" width="144"></p>

<h1 align="center">LiveBridge</h1>

<p align="center"><strong>Parlez à voix haute à une session Claude Code ouverte.</strong></p>

<p align="center">Pour qui utilise Claude Code sur un Mac Apple Silicon, avec une offre ChatGPT dont le Codex inclut la voix.</p>

<p align="center">
  <a href="https://github.com/getLiveBridge/LiveBridge/actions/workflows/ci.yml"><img src="https://github.com/getLiveBridge/LiveBridge/actions/workflows/ci.yml/badge.svg?branch=main" alt="CI"></a>
  <a href="https://scorecard.dev/viewer/?uri=github.com/getLiveBridge/LiveBridge"><img src="https://api.scorecard.dev/projects/github.com/getLiveBridge/LiveBridge/badge" alt="OpenSSF Scorecard"></a>
  <a href="https://www.bestpractices.dev/projects/16502"><img src="https://www.bestpractices.dev/projects/16502/badge" alt="OpenSSF Best Practices"></a>
  <a href="../../LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="Licence : MIT"></a>
  <img src="https://img.shields.io/badge/platform-macOS%2014%2B%20%C2%B7%20Apple%20Silicon-lightgrey.svg" alt="Plateforme : macOS 14+ sur Apple Silicon">
</p>

<p align="center">
  <a href="https://getlivebridge.com">getlivebridge.com</a> ·
  <a href="#démarrage-rapide">Démarrage rapide</a> ·
  <a href="#installation">Installation</a> ·
  <a href="#utilisation">Utilisation</a> ·
  <a href="#facturation-maîtrisée-par-conception">Facturation</a> ·
  <a href="#confidentialité">Confidentialité</a> ·
  <a href="#limitations-connues">Limitations</a> ·
  <a href="#feuille-de-route-et-aide-recherchée">Aide recherchée</a> ·
  <a href="#contribuer">Contribuer</a>
</p>

LiveBridge est une application de barre des menus macOS qui garde une ligne vocale GPT-Live prête à
l'emploi via `codex app-server`, avec votre connexion ChatGPT (sans clé d'API). La voix fait office
d'accueil : elle discute, demande ce que vous voulez dire, et confie le vrai travail à votre session
Claude Code par l'intermédiaire d'un petit mod Claude Code, `livebridge`. Claude fait le travail
avec son propre modèle, ses propres outils et son propre mode de permissions, et la voix vous
annonce le résultat. Inutile de garder la ligne ouverte pendant que Claude travaille : sa réponse
rouvre la ligne fermée et passe à la voix pour qu'elle la dise. La voix suit aussi ce que vous tapez
dans la session et ce que Claude répond, vous pouvez donc passer de la parole au clavier.

*Le texte anglais fait foi ([README.md](../../README.md)) ; cette traduction peut avoir du retard.*

**Une conversation, pas une dictée.** GPT-Live écoute pendant qu'il parle : coupez-le et il s'arrête pour vous écouter ; réfléchissez à voix haute et il peut glisser un petit « mm-hmm ». **La ligne se ferme quand la conversation se tait :** OpenAI facture la voix à la minute, donc après un silence dont vous fixez la durée dans [Settings](guide.fr.md#réglages) (20 secondes par défaut), la ligne se ferme, et elle se rouvre quand vous parlez, la conversation reprenant là où vous l'aviez laissée. Le silence avant la fermeture est facturé, tout comme l'attente, jusqu'à 2 minutes, de la réponse de Claude après une transmission ; **Mute** ne ferme pas la ligne et n'économise donc aucune minute ([Facturation](#facturation-maîtrisée-par-conception)).

<p align="center"><img src="../assets/readme-demo.gif" alt="Conversation avec une session Claude Code via LiveBridge" width="100%"></p>

<p align="center">Le GIF est muet : <a href="https://getlivebridge.com/assets/livebridge-demo.mp4">regardez la démo de 64 secondes avec le son</a> sur getlivebridge.com.</p>

**Local par conception.** Pas de télémétrie et pas de serveur propre : LiveBridge est un pont sur
votre Mac entre votre propre codex et votre propre Claude Code. L'application et le mod
communiquent uniquement par un socket Unix que seul votre utilisateur peut ouvrir, et
l'application n'écoute sur aucun port réseau. En dehors de ce que ces deux outils envoient déjà
(la ligne vocale vers OpenAI via votre codex, uniquement tant qu'elle est ouverte, avec ce que vous tapez dans une session rejointe, et le travail
de Claude vers Anthropic via votre session Claude Code), le seul trafic propre à l'application
est un codex éphémère qui, à l'ouverture du menu, demande à OpenAI vos chiffres d'utilisation de
Codex, même quand l'appel est coupé, et celui des [mises à jour](guide.fr.md#mises-à-jour) : une demande automatique à GitHub pour savoir s'il existe
une nouvelle version (quotidienne, et à chaque lancement tant qu'une version qu'elle a annoncée
n'est pas installée), que vous pouvez désactiver ; la même demande quand vous cliquez sur **Check
for update** ; `gh auth status` quand une nouvelle version est annoncée ; et, quand vous cliquez
sur **Install**, le téléchargement, sa vérification et la mise à jour du mod.
[Confidentialité](privacy.fr.md) liste précisément ce qui parvient à OpenAI et nomme les
requêtes de l'application vers GitHub ; [SECURITY.md](../../SECURITY.md) explique ce que cela protège
et ce que cela ne protège pas.

> **Statut :** 0.x, un seul mainteneur. **Non officiel :** ni affilié à Anthropic ou OpenAI, ni
> approuvé ni soutenu par eux. LiveBridge utilise l'API temps réel expérimentale de codex avec votre
> connexion ChatGPT, qu'OpenAI ne documente pas comme une voie pour les applications tierces, et une
> version de codex peut la casser. Utilisez-le à vos propres risques.
>
> **Il vous faut :** Apple Silicon avec macOS 14 ou ultérieur, Claude Code 2.1.301 ou ultérieur, et
> [codex](https://github.com/openai/codex) connecté (`codex login`) à une offre ChatGPT dont le Codex
> inclut la voix ; les minutes de voix sont décomptées de cette offre. Pour compiler l'application
> vous-même, il faut aussi Xcode avec Swift 6.0 ou ultérieur. Le détail se trouve sous
> [Prérequis](#prérequis).

## Démarrage rapide

```sh
# 1. The app, from LiveBridge's own Homebrew tap
brew install --cask getlivebridge/tap/livebridge

# 2. The mod, from this repository's marketplace
claude plugin marketplace add getLiveBridge/LiveBridge
claude plugin install livebridge@livebridge
```

3. Ouvrez LiveBridge depuis Applications. La première fois, macOS demande s'il faut ouvrir une
   application téléchargée depuis internet ; cliquez sur **Open**. LiveBridge vit dans la barre des
   menus.
4. Dans la session Claude Code à laquelle vous voulez parler, tapez `/live`. Elle répond « Joined
   LiveBridge. », et une bande apparaît au-dessus du prompt avec **Voice off**, la session à laquelle
   parle l'appel, et **Start**.
5. Appuyez sur **Start**. La première fois, macOS demande l'accès au microphone : autorisez-le. Il
   peut aussi demander si LiveBridge peut trouver des appareils sur votre réseau local ; la ligne
   vocale en a besoin aussi. La bande affiche alors **Listening** : un détecteur de voix sur votre
   Mac attend que vous parliez, et rien n'est encore envoyé.
6. Demandez « Sur quoi travaille cette session ? ». La bande affiche **Connecting**, puis **Live**,
   et la voix répond, à partir de la conversation de la session ou en transmettant la question à
   Claude. Demandez une modification : la voix la transmet à Claude et vous dit le résultat quand
   Claude a fini. Quand la conversation se tait, la ligne se ferme et la bande affiche de nouveau
   **Listening** ([quand](#facturation-maîtrisée-par-conception)).

Pas de Homebrew ? Chaque [version](https://github.com/getLiveBridge/LiveBridge/releases/latest)
fournit l'application sous forme d'image disque, compilée et attestée par GitHub Actions
([Depuis l'image disque](#depuis-limage-disque)), ou compilez-la vous-même
([Depuis les sources](#depuis-les-sources)). Le mod s'installe de la même manière dans tous les cas.

Si `/live` est introuvable dans une session déjà ouverte, rouvrez la session
([pourquoi](#limitations-connues)). [Installation](#installation) couvre l'image disque, la
compilation depuis les sources et les autorisations ; [Mises à jour](guide.fr.md#mises-à-jour),
[Désinstallation](guide.fr.md#désinstallation) et [Utilisation](#utilisation) couvrent le reste.

## Prérequis

- macOS 14 ou ultérieur sur Apple Silicon.
- Claude Code 2.1.301 ou ultérieur.
- [Codex CLI](https://github.com/openai/codex) (`codex`, testé avec 0.172.0), installé avec
  Homebrew (`brew install --cask codex`) ou npm (`npm install -g @openai/codex`), présent dans le
  `PATH` que votre shell définit dans une fenêtre Terminal, et connecté avec `codex login` à une
  offre ChatGPT dont le Codex inclut la voix (Plus, Pro, Business, Enterprise ou Education, selon
  les [tarifs de Codex d'OpenAI](https://learn.chatgpt.com/docs/pricing)). LiveBridge refuse un codex dont il ne peut pas
  lire le `codex features list`, donc une autre version peut ne pas démarrer tant que LiveBridge
  n'a pas été mis à jour.
- Pour compiler l'application : Xcode avec une chaîne d'outils Swift 6.0 ou ultérieure. Les
  versions testées sont indiquées dans [CONTRIBUTING.md](../../CONTRIBUTING.md#toolchain).
  L'application compilée fonctionne sur macOS 14 ou ultérieur.

## Installation

Le mod provient de la marketplace de ce dépôt (les commandes du [Démarrage
rapide](#démarrage-rapide)), qui désigne le tag de la dernière version : le mod que vous
installez est donc celui de cette version. L'application va dans `/Applications` dans les deux
cas : depuis l'image disque, ou compilée depuis les sources. À partir de la première version
postérieure à 0.4.2, l'image disque est signée avec le Developer ID de LiveBridge et notarisée par
Apple ; la 0.4.2 et les précédentes étaient signées ad hoc et non notarisées, et une compilation
depuis les sources n'est ni signée avec le Developer ID ni notarisée.

### Depuis l'image disque

1. Téléchargez
   [LiveBridge.dmg](https://github.com/getLiveBridge/LiveBridge/releases/latest/download/LiveBridge.dmg)
   depuis la dernière version.
2. Vérifiez-la avec la [GitHub CLI](https://cli.github.com), dans le dossier où vous l'avez
   enregistrée :

   ```sh
   gh attestation verify LiveBridge.dmg --repo getLiveBridge/LiveBridge \
     --signer-workflow getLiveBridge/LiveBridge/.github/workflows/release.yml \
     --source-ref refs/tags/vX.Y.Z --deny-self-hosted-runners
   ```

   où `vX.Y.Z` est le tag de la version, tel que sa page le nomme. La vérification ne réussit que
   pour une image que le [workflow de publication](../../.github/workflows/release.yml) de ce dépôt a
   compilée à partir de ce tag, sur un runner hébergé par GitHub, et qui n'a pas changé depuis.
   Sur une version postérieure à 0.4.2, la signature Developer ID, que macOS vérifie de
   lui-même, dit qui a signé l'image, et cette vérification dit à partir de quoi elle a été
   compilée ; sur la 0.4.2 et les précédentes, dont la signature ad hoc ne nomme personne, cette
   vérification est l'unique preuve d'origine de l'image. Elle ne prouve pas que quiconque ait
   relu le code.
3. Ouvrez-la et faites glisser LiveBridge dans Applications.
4. Au premier lancement, une version postérieure à 0.4.2 fait demander à macOS s'il faut ouvrir
   une application téléchargée sur Internet ; cliquez sur **Open**. La 0.4.2 et les précédentes
   sont bloquées tant que vous ne les autorisez pas dans Réglages Système > Confidentialité et
   sécurité > **Open Anyway**.

### Avec Homebrew

```sh
brew install --cask getlivebridge/tap/livebridge
```

Cette commande installe la même image disque depuis le [tap de LiveBridge](https://github.com/getLiveBridge/homebrew-tap), qui n'est pas un
cask officiel de Homebrew. Homebrew peut d'abord vous demander de faire confiance à ce tap, et macOS
demande confirmation au premier lancement comme indiqué plus haut. L'application se met ensuite à jour seule
([Mises à jour](guide.fr.md#mises-à-jour)).

### Depuis les sources

`scripts/build-app.sh --release` compile l'application, l'installe dans `/Applications` (votre
compte doit pouvoir y écrire, comme celui d'un administrateur) et l'ouvre. Relancez-le pour
recompiler. La compilation est signée ad hoc, donc macOS redemande l'accès au microphone après
chaque recompilation. Pour conserver l'autorisation, exécutez une fois
`scripts/build-app.sh --make-signing-identity` : il demande d'abord confirmation, puis crée dans
votre trousseau de session un certificat de signature de code auto-signé, et les compilations
release suivantes sont signées avec lui.

La marketplace épingle le mod au tag de la dernière version : une application compilée depuis la
branche principale tourne donc avec le mod de cette version. Pour les faire correspondre,
compilez le tag de la version (`git checkout vX.Y.Z`) ou chargez le mod de votre copie de travail
avec `claude --plugin-dir plugin`.

Une compilation depuis les sources ne vérifie les mises à jour d'elle-même que si vous l'activez
dans Settings. Installer une mise à jour la remplace par l'image de la version, signée avec le
Developer ID de LiveBridge et non avec votre certificat auto-signé, si bien que macOS redemande
l'accès au microphone une fois ; **Install** le signale et demande d'abord confirmation.

### Autorisations

Le premier Start demande à macOS l'accès au microphone. S'il a été refusé, l'appel s'arrête avec
une phrase d'explication, et **Open Microphone Settings** dans le menu de la barre des menus
ouvre Confidentialité et sécurité > Microphone, où vous autorisez LiveBridge. macOS redemande au
premier Start après la première mise à jour depuis une version ad hoc, et après chaque
recompilation depuis les sources signée ad hoc (voir ci-dessus). macOS peut aussi demander si LiveBridge peut trouver des appareils sur votre réseau
local. La ligne vocale a besoin de cette seconde autorisation également ; sans elle, l'appel
s'arrête avec une phrase qui indique où l'accorder.

### Mises à jour et désinstallation

LiveBridge se met à jour, lui et son mod, quand vous cliquez sur **Install**, et jamais de lui-même ;
[Mises à jour](guide.fr.md#mises-à-jour) dit ce qu'il vérifie d'abord et comment mettre à jour à la
main. [Désinstallation](guide.fr.md#désinstallation) couvre l'élément de menu
**Uninstall LiveBridge…**, Homebrew, un clone du dépôt et les étapes à la main.

## Limitations connues

[known-limitations.fr.md](known-limitations.fr.md) donne la liste complète, avec l'enregistrement
derrière chaque point mesuré. En bref :

- **La voix est un modèle de langage, et elle ne fait pas toujours ce qu'on lui dit.** Elle dit
  parfois qu'elle regarde sans transmettre la demande, si bien que rien n'atteint Claude : si le
  petit son d'une demande mise en file ne suit pas, répétez-la. Elle peut rester muette quand la
  réponse de Claude rouvre la ligne ; la réponse sonne alors un carillon et attend. Elle peut ne pas
  mentionner une question ou une demande d'autorisation que Claude attend, donc ne comptez pas sur
  elle pour vous l'annoncer quand vous êtes loin du Mac. La demande attend toujours dans Claude
  Code, et LiveBridge n'y répond jamais.
- **À la limite d'utilisation de votre offre ChatGPT**, la voix s'arrête jusqu'à la
  réinitialisation de la limite. Claude Code continue de travailler, et ses réponses attendent.
- **Là où une organisation gère Claude Code**, rien dans LiveBridge ne vous dit qu'une demande
  d'autorisation attend, et certains réglages gérés empêchent le mod de se charger.
- **`/live`** peut exiger de rouvrir la session si elle était ouverte avant le chargement du mod.
- **Connect over TCP** préfère TCP sans l'imposer, et rien ne montre quel transport une ligne a pris.
- Savoir si la voix a dit un résultat en attente se juge à ses mots, en anglais et en russe
  seulement. La liste complète couvre aussi les prompts qui n'ont pas été tapés, les fournisseurs
  sans le modèle de résumé et les sessions encore sur un ancien mod.

## Utilisation

Dans la session Claude Code à laquelle vous voulez parler, `/live` la relie à LiveBridge et
`/live off` l'en retire. **Start**, dans la bande au-dessus du prompt ou dans le menu de la barre des
menus, lance l'appel ; **Mute** libère le microphone pendant que l'appel continue, **Stop** met fin à
l'appel, et **Talk here** le passe à la session dans la bande de laquelle vous appuyez. Le menu de la
barre des menus liste les sessions reliées, la conversation de la cible avec la voix, vos minutes et
votre utilisation, et **Settings…** : la voix, votre propre prompt pour elle, combien de temps le
silence garde la ligne ouverte et comment vos sessions atteignent la voix.

[guide.fr.md](guide.fr.md) décrit chaque commande, la bande, le menu et chaque réglage, et ce que la
voix fait de vos demandes et des réponses et questions de Claude.

## Facturation maîtrisée par conception

Une ligne vocale en temps réel coûte tant qu'elle est ouverte, donc LiveBridge ne l'ouvre que pendant
que quelqu'un parle, tant que la réponse de Claude à votre demande peut encore arriver (jusqu'à 2
minutes après chaque transmission), ou pour vous dire la réponse de Claude, une question qu'il vous
pose ou qu'il attend votre approbation. Tant que la ligne est fermée, le microphone n'alimente qu'un
détecteur de voix sur votre Mac, et aucun son n'est envoyé. Le menu affiche les minutes pendant
lesquelles la ligne a été ouverte et la part utilisée de votre usage Codex et Claude ; la page
d'utilisation de votre offre fait foi.
[guide.fr.md](guide.fr.md#facturation-maîtrisée-par-conception) donne chaque règle.

## Confidentialité

En bref : pas de télémétrie, pas de serveur à lui et aucun port réseau, et votre voix, ce que vous
tapez dans une session reliée, ainsi que les réponses et résumés de Claude atteignent OpenAI via
votre codex seulement tant qu'une ligne est ouverte. [privacy.fr.md](privacy.fr.md) énumère chaque
élément qui atteint OpenAI et ses limites, ce que couvre le filtre d'identifiants, chaque requête
vers GitHub et ce que l'application garde sur votre Mac.

[SECURITY.md](../../SECURITY.md) contient le modèle de menace : en bref, tout ce que votre microphone
peut entendre peut devenir une demande que Claude exécute avec le mode de permissions propre à la
session.

## Fonctionnement

[docs/architecture/overview.md](../../docs/architecture/overview.md) décrit les composants, le protocole
entre le mod et l'application, et les flux de messages ;
l'[ADR 0001](../../docs/adr/0001-platform-findings.md) consigne les faits de plateforme sur lesquels
repose la conception.

## Feuille de route et aide recherchée

LiveBridge est aujourd'hui une application Mac, un exécutant (Claude Code) et un fournisseur de
voix (codex avec une connexion ChatGPT). Les trois se rencontrent à des jointures étroites, et
chacune des directions ci-dessous est ouverte aux contributeurs. Les tickets qui les concernent
portent le label
[help wanted](https://github.com/getLiveBridge/LiveBridge/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22) ;
[CONTRIBUTING.md](../../CONTRIBUTING.md#where-to-start) indique les fichiers à lire en premier.

- **Windows et Linux.** L'application de barre des menus, sa page audio et le serveur de socket
  sont liés à macOS ; le protocole entre le mod et l'application, ainsi que le mod lui-même, sont
  portables. Un portage commence par une application pour la nouvelle plateforme qui parle le même
  protocole.
- **D'autres agents comme exécutant**, tels que Codex CLI, Hermes Agent ou Gemini CLI : chacun
  nécessite son propre adaptateur parlant le même protocole que le mod Claude Code.
- **D'autres fournisseurs de voix**, tels que l'API OpenAI Realtime avec votre propre clé d'API ou
  l'API Gemini Live de Google : chacun serait une autre implémentation du protocole temps réel de
  l'application.

## Contribuer

Les contributions sont les bienvenues. Pour tout ce qui dépasse un correctif, ouvrez d'abord un
ticket afin de s'accorder sur la forme avant de commencer le travail. Bons points de départ : les
tickets [help wanted](https://github.com/getLiveBridge/LiveBridge/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22),
les [limitations connues](#limitations-connues) et les directions
[ci-dessus](#feuille-de-route-et-aide-recherchée).

- [CONTRIBUTING.md](../../CONTRIBUTING.md) : l'organisation du dépôt, la chaîne d'outils, les
  vérifications (`scripts/check.sh`) et les conventions.
- [Formulaires de tickets](https://github.com/getLiveBridge/LiveBridge/issues/new/choose) : signalez un bug ou demandez une fonctionnalité.
- [CODE_OF_CONDUCT.md](../../CODE_OF_CONDUCT.md) : comment nous nous traitons ici.
- [SECURITY.md](../../SECURITY.md) : signalez une vulnérabilité en privé, pas dans un ticket public.
- [CHANGELOG.md](../../CHANGELOG.md) : ce qui a changé dans chaque version.

## Crédits

Le protocole entre le mod et l'application s'est inspiré de
[claude-code-voice-mod](https://github.com/ldk00315-jpg/claude-code-voice-mod). Aucun code ni
texte n'en a été copié.

## Licence

[MIT](../../LICENSE).
