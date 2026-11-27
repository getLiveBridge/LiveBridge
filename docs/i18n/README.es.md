<p align="center"><a href="../../README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.hi.md">हिन्दी</a> · <b>Español</b> · <a href="README.fr.md">Français</a> · <a href="README.ru.md">Русский</a> · <a href="README.uk.md">Українська</a></p>

<p align="center"><img src="../../site/assets/icon.png" alt="Icono de la aplicación LiveBridge" width="144"></p>

<h1 align="center">LiveBridge</h1>

<p align="center"><strong>Habla por voz con una sesión abierta de Claude Code.</strong></p>

<p align="center">Para quienes usan Claude Code en un Mac con Apple Silicon y tienen un plan de ChatGPT cuyo Codex incluye voz.</p>

<p align="center">
  <a href="https://github.com/getLiveBridge/LiveBridge/actions/workflows/ci.yml"><img src="https://github.com/getLiveBridge/LiveBridge/actions/workflows/ci.yml/badge.svg?branch=main" alt="CI"></a>
  <a href="https://scorecard.dev/viewer/?uri=github.com/getLiveBridge/LiveBridge"><img src="https://api.scorecard.dev/projects/github.com/getLiveBridge/LiveBridge/badge" alt="OpenSSF Scorecard"></a>
  <a href="https://www.bestpractices.dev/projects/16502"><img src="https://www.bestpractices.dev/projects/16502/badge" alt="OpenSSF Best Practices"></a>
  <img src="https://img.shields.io/badge/platform-macOS%2014%2B%20%C2%B7%20Apple%20Silicon-lightgrey.svg" alt="Plataforma: macOS 14+ en Apple Silicon">
</p>

<p align="center">
  <a href="https://getlivebridge.com">getlivebridge.com</a> ·
  <a href="#inicio-rápido">Inicio rápido</a> ·
  <a href="#instalación">Instalación</a> ·
  <a href="#uso">Uso</a> ·
  <a href="#facturación-bajo-control-por-diseño">Facturación</a> ·
  <a href="#privacidad">Privacidad</a> ·
  <a href="#limitaciones-conocidas">Limitaciones</a> ·
  <a href="#hoja-de-ruta-y-ayuda-buscada">Ayuda buscada</a> ·
  <a href="#contribuir">Contribuir</a>
</p>

LiveBridge es una aplicación de la barra de menús de macOS que mantiene lista una línea de voz
GPT-Live a través de `codex app-server` con tu inicio de sesión de ChatGPT (sin clave de API). La
voz es la recepción: conversa, pregunta qué quieres decir y pasa el trabajo real a tu sesión de
Claude Code mediante un pequeño mod de Claude Code, `livebridge`. Claude hace el trabajo con su
propio modelo, sus herramientas y su modo de permisos, y la voz te cuenta el resultado. No hace
falta mantener la línea abierta mientras Claude trabaja: su respuesta vuelve a abrir la línea
cerrada y pasa a la voz para que la diga. La voz también sigue lo que escribes en la sesión y lo que
responde Claude, así que puedes alternar entre hablar y escribir.

*El texto en inglés es el canónico ([README.md](../../README.md)); esta traducción puede ir por detrás.*

**Una conversación, no un dictado.** GPT-Live escucha mientras habla: interrúmpelo y se detiene para oírte; piensa en voz alta y puede soltar un breve «ajá». **La línea se cierra cuando la conversación se calla:** OpenAI cobra la voz por minuto, así que tras un rato de silencio que fijas en [Ajustes](guide.es.md#ajustes) (20 segundos por defecto) la línea se cierra y se abre de nuevo cuando hablas, con la conversación donde la dejaste. El silencio antes del cierre se cobra, igual que la espera de hasta 2 minutos a la respuesta de Claude tras un traspaso; **Mute** no cierra la línea, así que no ahorra minutos ([Facturación](#facturación-bajo-control-por-diseño)).

<p align="center"><img src="../assets/readme-demo.gif" alt="Hablando con una sesión de Claude Code a través de LiveBridge" width="100%"></p>

<p align="center">El GIF no tiene sonido: <a href="https://getlivebridge.com/assets/livebridge-demo.mp4">mira la demo de 64 segundos con sonido</a> en getlivebridge.com.</p>

**Local por diseño.** Sin telemetría y sin servidor propio: LiveBridge es un puente en tu Mac
entre tu propio codex y tu propio Claude Code. La aplicación y el mod se comunican por un socket
Unix que solo tu usuario puede abrir, y la aplicación no escucha en ningún puerto de red. Además
de lo que esas dos herramientas ya envían (la línea de voz a OpenAI a través de tu codex, solo mientras está abierta, con lo que escribes en una sesión unida, y el trabajo de Claude a Anthropic a través de tu sesión de Claude Code),
el único tráfico propio de la aplicación es un codex de vida corta que, al abrir el menú, pide a
OpenAI las cifras de uso de Codex, también con la llamada apagada, y el de las
[actualizaciones](guide.es.md#actualización): una
consulta automática a GitHub por si hay una versión nueva (diaria, y en cada arranque mientras no
se haya instalado una que anunció), que puedes desactivar; la misma consulta cuando pulsas **Check
for update**; `gh auth status` cuando se anuncia una versión nueva; y, cuando pulsas **Install**,
la descarga, su verificación y la actualización del mod. [Privacidad](privacy.es.md) enumera
exactamente qué llega a OpenAI y nombra las peticiones de la aplicación a GitHub;
[SECURITY.md](../../SECURITY.md) explica de qué protege y de qué no protege.

> **Estado:** 0.x, un solo mantenedor. **No oficial:** sin afiliación, respaldo ni soporte de
> Anthropic u OpenAI. LiveBridge usa la API experimental de tiempo real de codex con tu inicio de
> sesión de ChatGPT, que OpenAI no documenta como vía para aplicaciones de terceros, y una versión de
> codex puede romperlo. Úsalo bajo tu propia responsabilidad.
>
> **Necesitas:** Apple Silicon con macOS 14 o posterior, Claude Code 2.1.301 o posterior y
> [codex](https://github.com/openai/codex) con sesión iniciada (`codex login`) en un plan de ChatGPT
> cuyo Codex incluya voz; los minutos de voz se descuentan de ese plan. Para compilar la aplicación
> tú mismo, también Xcode con Swift 6.0 o posterior. Los detalles están en [Requisitos](#requisitos).

## Inicio rápido

```sh
# 1. The app, from LiveBridge's own Homebrew tap
brew install --cask getlivebridge/tap/livebridge

# 2. The mod, from this repository's marketplace
claude plugin marketplace add getLiveBridge/LiveBridge
claude plugin install livebridge@livebridge
```

3. Abre LiveBridge desde Aplicaciones. La primera vez, macOS pregunta si quieres abrir una
   aplicación descargada de internet; pulsa **Open**. LiveBridge vive en la barra de menús.
4. En la sesión de Claude Code con la que quieras hablar, escribe `/live`. Responde «Joined
   LiveBridge.» y sobre el prompt aparece una banda con **Voice off**, la sesión con la que habla la
   llamada y **Start**.
5. Pulsa **Start**. La primera vez, macOS pide el micrófono: permítelo. También puede preguntar si
   LiveBridge puede encontrar dispositivos en tu red local; la línea de voz también lo necesita. La
   banda muestra ahora **Listening**: un detector de voz en tu Mac espera a que hables, y ningún
   audio sale de tu Mac hasta que lo haces. Con un mod actual, Start ya pide a la sesión un breve
   resumen cuando a la voz le falta parte de ella, como en una primera llamada, salvo que **Pause
   sync** lo retenga: Claude lo escribe a través de tu Claude Code, a cargo de tu uso de Claude, y
   llega a OpenAI solo con la línea ([cuándo](guide.es.md#la-banda-y-el-menú)).
6. Pregunta «¿En qué está trabajando esta sesión?». La banda muestra **Connecting** y luego
   **Live**, y la voz responde, desde la conversación de la sesión o pasando la pregunta a Claude.
   Pide un cambio y la voz se lo pasa a Claude y te dice el resultado cuando Claude termina. Cuando
   la conversación se calla, la línea se cierra y la banda vuelve a mostrar **Listening**
   ([cuándo](#facturación-bajo-control-por-diseño)).

¿Sin Homebrew? Cada [versión](https://github.com/getLiveBridge/LiveBridge/releases/latest) incluye
la aplicación como imagen de disco, compilada y atestada por GitHub Actions
([Desde la imagen de disco](#desde-la-imagen-de-disco)), o compílala tú mismo
([Desde el código fuente](#desde-el-código-fuente)). El mod se instala igual en cualquier caso.

Si `/live` no se encuentra en una sesión que ya estaba abierta, vuelve a abrir la sesión
([por qué](#limitaciones-conocidas)). [Instalación](#instalación) cubre la imagen de disco, la
compilación desde el código fuente y los permisos; [Actualización](guide.es.md#actualización),
[Desinstalación](guide.es.md#desinstalación) y [Uso](#uso) cubren el resto.

## Requisitos

- macOS 14 o posterior en Apple Silicon.
- Claude Code 2.1.301 o posterior.
- [Codex CLI](https://github.com/openai/codex) (`codex`, probado con 0.172.0), instalado con
  Homebrew (`brew install --cask codex`) o npm (`npm install -g @openai/codex`), en el `PATH` que
  tu shell define en una ventana de Terminal, y con sesión iniciada mediante `codex login` en un
  plan de ChatGPT cuyo Codex incluya voz (Plus, Pro, Business, Enterprise o Education, según los
  [precios de Codex de OpenAI](https://learn.chatgpt.com/docs/pricing)). LiveBridge rechaza un codex cuyo
  `codex features list` no pueda leer, por lo que es posible que otra versión no arranque hasta
  que se actualice LiveBridge.
- Para compilar la aplicación: Xcode con una toolchain de Swift 6.0 o posterior. Las versiones
  probadas están en [CONTRIBUTING.md](../../CONTRIBUTING.md#toolchain). La aplicación compilada funciona
  en macOS 14 o posterior.

## Instalación

El mod viene del marketplace de este repositorio (los comandos de [Inicio rápido](#inicio-rápido)),
que apunta a la etiqueta de la última versión, así que el mod que instalas es el de esa versión. La
aplicación va en `/Applications` la instales como la instales: con Homebrew, desde la imagen de
disco o compilada desde el código fuente. Desde la primera versión posterior a 0.4.2, la imagen de
disco, que Homebrew también instala, está firmada con el Developer ID de LiveBridge y notarizada por
Apple; la 0.4.2 y las anteriores se firmaron ad hoc y no están notarizadas, y una compilación desde
el código fuente ni está firmada con el Developer ID ni notarizada.

### Desde la imagen de disco

1. Descarga
   [LiveBridge.dmg](https://github.com/getLiveBridge/LiveBridge/releases/latest/download/LiveBridge.dmg)
   de la última versión.
2. Compruébala con la [GitHub CLI](https://cli.github.com), en la carpeta donde la guardaste:

   ```sh
   gh attestation verify LiveBridge.dmg --repo getLiveBridge/LiveBridge \
     --signer-workflow getLiveBridge/LiveBridge/.github/workflows/release.yml \
     --source-ref refs/tags/vX.Y.Z --deny-self-hosted-runners
   ```

   donde `vX.Y.Z` es la etiqueta de la versión, tal como la nombra su página. Solo se supera con
   una imagen que el [flujo de trabajo de publicación](../../.github/workflows/release.yml) de este
   repositorio haya compilado a partir de esa etiqueta, en un runner alojado por GitHub, y que no
   haya cambiado desde entonces. En una versión posterior a 0.4.2, la firma Developer ID, que macOS
   comprueba por sí solo, dice quién firmó la imagen, y esta comprobación dice a partir de qué se
   compiló; en la 0.4.2 y las anteriores, cuya firma ad hoc no nombra a nadie, esta comprobación
   es la única prueba de origen de la imagen. No prueba que nadie haya revisado el código.
3. Ábrela y arrastra LiveBridge a Aplicaciones.
4. En el primer arranque, una versión posterior a 0.4.2 hace que macOS pregunte si abrir una
   aplicación descargada de internet; pulsa **Open**. La 0.4.2 y las anteriores quedan bloqueadas
   hasta que las permitas en Ajustes del Sistema > Privacidad y seguridad > **Open Anyway**.

### Con Homebrew

```sh
brew install --cask getlivebridge/tap/livebridge
```

Instala la misma imagen de disco desde el [tap propio de LiveBridge](https://github.com/getLiveBridge/homebrew-tap), que no es un cask oficial
de Homebrew. Homebrew puede pedirte primero que confíes en el tap, y macOS pregunta en el primer inicio
como se indica arriba. Después la aplicación se actualiza sola
([Actualización](guide.es.md#actualización)).

### Desde el código fuente

`scripts/build-app.sh --release` compila la aplicación, la instala en `/Applications` (tu cuenta
debe poder escribir ahí, como puede la de un administrador) y la abre. Ejecútalo de nuevo para
recompilar. La compilación se firma ad hoc, así que macOS vuelve a pedir el micrófono después de
cada recompilación. Para conservar el permiso, ejecuta una vez
`scripts/build-app.sh --make-signing-identity`: pregunta antes, crea un certificado de firma de
código autofirmado en tu llavero de inicio de sesión, y las compilaciones de release posteriores se
firman con él.

El marketplace fija el mod a la etiqueta de la última versión, así que una aplicación compilada
desde la rama principal funciona con el mod de esa versión. Para que coincidan, compila la
etiqueta de la versión (`git checkout vX.Y.Z`) o carga el mod de tu copia de trabajo con
`claude --plugin-dir plugin`.

Una compilación desde el código fuente busca actualizaciones por sí sola solo si lo activas en
Settings. Instalar una actualización la reemplaza por la imagen de la versión, que está firmada con el
Developer ID de LiveBridge, no con tu certificado autofirmado, así que macOS vuelve a pedir el
micrófono una vez; **Install** lo dice y pregunta antes.

### Permisos

El primer Start pide a macOS el micrófono. Si se denegó, la llamada se detiene con una frase y la
opción **Open Microphone Settings** del menú de la barra de menús abre Privacidad y seguridad >
Micrófono, donde permites LiveBridge. macOS vuelve a preguntar en el primer
Start tras la primera actualización desde una versión ad hoc, y tras cada recompilación desde el
código fuente firmada ad hoc (véase más arriba). Es posible que macOS también
pregunte si LiveBridge puede encontrar dispositivos en tu red local. La línea de voz necesita
también este segundo permiso; sin él, la llamada se detiene con una frase que indica dónde
permitirlo.

### Actualización y desinstalación

LiveBridge se actualiza a sí mismo y a su mod cuando pulsas **Install**, y nunca por su cuenta;
[Actualización](guide.es.md#actualización) explica qué comprueba antes y cómo actualizar a mano.
[Desinstalación](guide.es.md#desinstalación) cubre el elemento del menú **Uninstall LiveBridge…**,
Homebrew, un clon del repositorio y los pasos a mano.

## Limitaciones conocidas

[known-limitations.es.md](known-limitations.es.md) tiene la lista completa, con el registro detrás de
cada punto medido. En resumen:

- **La voz es un modelo de lenguaje y no siempre hace lo que se le dice.** A veces dice que está
  mirando sin pasar la petición, así que nada llega a Claude: si no sigue el sonido corto de una
  petición en cola, repítela. Puede quedarse callada cuando la respuesta de Claude reabre la línea;
  entonces la respuesta suena con un timbre y espera. Puede no mencionar una pregunta o una
  solicitud de permiso que Claude espera, así que no confíes en que te la anuncie cuando estés lejos
  del Mac. La solicitud sigue esperando en Claude Code, y LiveBridge nunca la responde.
- **Al llegar al límite de uso de tu plan de ChatGPT** la voz se detiene hasta que el límite se
  reinicia. Claude Code sigue trabajando, y sus respuestas esperan.
- **Donde una organización gestiona Claude Code**, nada en LiveBridge te avisa de que espera una
  solicitud de permiso, y algunos ajustes gestionados impiden que el mod se cargue.
- **`/live`** puede requerir reabrir la sesión si estaba abierta antes de que se cargara el mod.
- **Connect over TCP** prefiere TCP pero no lo fuerza, y nada muestra durante la llamada qué
  transporte tomó una línea; el modo de depuración lo registra (`onTcp`).
- Si la voz ya dijo un resultado en espera se juzga por sus palabras, solo en inglés y ruso. La lista
  completa también trata los prompts que no se escribieron, los proveedores sin el modelo de resumen
  y las sesiones que siguen con un mod anterior.

## Uso

En la sesión de Claude Code con la que quieras hablar, `/live` la une a LiveBridge y `/live off` la
saca. **Start**, en la banda sobre el prompt o en el menú de la barra de menús, inicia la llamada;
**Mute** libera el micrófono mientras la llamada sigue, **Stop** termina la llamada y **Talk here** la
pasa a la sesión en cuya banda lo pulsas. El menú de la barra de menús lista las sesiones unidas, la
conversación del objetivo con la voz, tus minutos y tu uso, y **Settings…**: la voz, tu propio prompt
para ella, cuánto tiempo mantiene el silencio la línea abierta y cómo llegan tus sesiones a la voz.

[guide.es.md](guide.es.md) describe cada comando, la banda, el menú y cada ajuste, y lo que hace la
voz con tus peticiones y con las respuestas y preguntas de Claude.

## Facturación bajo control por diseño

Una línea de voz en tiempo real cuesta mientras está abierta, así que LiveBridge la abre solo
mientras alguien habla, mientras aún puede llegar la respuesta de Claude a tu petición (hasta 2
minutos después de cada traspaso), o para decirte la respuesta de Claude, una pregunta que te hace
o que espera tu aprobación. Mientras la línea está cerrada, el micrófono solo alimenta un detector de
voz en tu Mac y no se envía audio. El menú muestra los minutos que la línea estuvo abierta y cuánto
llevas usado de Codex y de Claude; la página de uso de tu plan es la referencia.
[guide.es.md](guide.es.md#facturación-bajo-control-por-diseño) tiene cada regla.

## Privacidad

En resumen: sin telemetría, sin servidor propio y sin puerto de red, y tu voz, lo que escribes en una
sesión unida y las respuestas y resúmenes de Claude llegan a OpenAI a través de tu codex solo
mientras una línea está abierta. [privacy.es.md](privacy.es.md) enumera cada elemento que llega a
OpenAI y sus límites, qué cubre el filtro de credenciales, cada petición a GitHub y lo que la
aplicación guarda en tu Mac.

[SECURITY.md](../../SECURITY.md) contiene el modelo de amenazas: en resumen, todo lo que tu micrófono
pueda oír puede convertirse en una petición que Claude ejecuta con el propio modo de permisos de la
sesión.

## Cómo funciona

[docs/architecture/overview.md](../../docs/architecture/overview.md) describe los componentes, el
protocolo entre el mod y la aplicación, y los flujos de mensajes;
[ADR 0001](../../docs/adr/0001-platform-findings.md) recoge los hechos de la plataforma en los que se
basa el diseño.

## Hoja de ruta y ayuda buscada

Hoy LiveBridge es una aplicación de Mac, un agente de trabajo (Claude Code) y un proveedor de voz
(codex con un inicio de sesión de ChatGPT). Los tres se unen en interfaces estrechas, y cada
dirección siguiente está abierta a colaboradores. Las incidencias correspondientes llevan la
etiqueta
[help wanted](https://github.com/getLiveBridge/LiveBridge/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22);
[CONTRIBUTING.md](../../CONTRIBUTING.md#where-to-start) indica los archivos que conviene leer primero.

- **Windows y Linux.** La aplicación de la barra de menús, su página de audio y el servidor de
  sockets están ligados a macOS; el protocolo entre el mod y la aplicación, y el propio mod, son
  portables. Un port empieza con una aplicación para la nueva plataforma que hable el mismo
  protocolo.
- **Otros agentes como agente de trabajo**, como Codex CLI, Hermes Agent o Gemini CLI: cada uno
  necesita su propio adaptador que hable el mismo protocolo que el mod de Claude Code.
- **Otros proveedores de voz**, como la OpenAI Realtime API con tu propia clave de API o la Gemini
  Live API de Google: cada uno sería otra implementación del protocolo en tiempo real de la
  aplicación.

## Contribuir

Las contribuciones son bienvenidas. Para cualquier cosa mayor que una corrección, abre antes una
incidencia para acordar el planteamiento antes de empezar el trabajo. Buenos lugares para empezar
son las incidencias
[help wanted](https://github.com/getLiveBridge/LiveBridge/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22),
las [limitaciones conocidas](#limitaciones-conocidas) y las direcciones de la
[hoja de ruta](#hoja-de-ruta-y-ayuda-buscada) anterior.

Puedes usar asistentes de programación: indica en la pull request qué partes generó una
herramienta, ejecuta `scripts/check.sh` y prepárate para explicar cada línea cambiada
([contribuciones asistidas por IA](../../CONTRIBUTING.md#ai-assisted-contributions)).

- [CONTRIBUTING.md](../../CONTRIBUTING.md): la estructura, la toolchain, las comprobaciones
  (`scripts/check.sh`) y las convenciones.
- [Formularios de incidencias](https://github.com/getLiveBridge/LiveBridge/issues/new/choose): informa de un error o pide una función.
- [CODE_OF_CONDUCT.md](../../CODE_OF_CONDUCT.md): cómo nos tratamos aquí.
- [SECURITY.md](../../SECURITY.md): informa de una vulnerabilidad en privado, no en una incidencia
  pública.
- [CHANGELOG.md](../../CHANGELOG.md): qué cambió en cada versión.

## Créditos

El protocolo entre el mod y la aplicación se inspiró en
[claude-code-voice-mod](https://github.com/ldk00315-jpg/claude-code-voice-mod). No se copió código
ni texto de él.

## Licencia

[MIT](../../LICENSE).
