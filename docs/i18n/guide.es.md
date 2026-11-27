# Cómo usar LiveBridge

*El texto en inglés es el canónico ([guide.md](../guide.md)); esta traducción puede ir por detrás.*

Cada comando, la banda, el menú y cada ajuste; lo que hace la voz; cómo se cobra la línea; y cómo
actualizar y desinstalar. El [README](README.es.md) tiene el resumen, los requisitos y la
instalación; [privacy.es.md](privacy.es.md), lo que sale de tu Mac; y
[known-limitations.es.md](known-limitations.es.md), lo que aún no funciona.

## Uso

### Comandos

En la sesión de Claude Code con la que quieras hablar:

| Comando | Qué hace |
|---|---|
| `/live` | Se une a LiveBridge con el título de la sesión y abre la aplicación si no se está ejecutando. En una sesión ya unida devuelve la banda y responde en una línea: la llamada, el destino, los resultados sin escuchar, los minutos de hoy. |
| `/live off` | Sale de LiveBridge. |

El comando es `/live` y no `/voice` porque `/voice` es el modo de voz propio de Claude Code. Que lo
que escribes en una sesión quede fuera de la voz mientras la llamada está detenida no es un comando: es un
único ajuste para todas las sesiones, en la ventana de [Ajustes](#ajustes) de LiveBridge.

### La banda y el menú

Pulsa **Start**, en la banda situada sobre el prompt o en el menú de la barra de menús, y habla.

- **El Start de la banda** convierte su sesión en el destino e inicia la llamada; la línea que abre
  recibe la conversación de la sesión, y carga además un resumen cuando a la voz le faltaría parte
  de ella (mira **Load context** abajo), pero con **Pause sync** activado o tras una pausa solo si aún no tiene ninguno
  ([detalles](../../docs/architecture/overview.md#when-the-app-asks)). Con un mod de esta versión, el resumen
  se pide al pulsar Start y al cambiar el destino durante la llamada, y la línea lo espera antes de
  conectar, como mucho [el límite de la espera](../../docs/architecture/overview.md#its-time): lo que digas mientras tanto se guarda en el Mac
  y llega a la voz al abrirse la línea. Stop o un cambio de destino durante la espera descartan lo
  guardado, y también una reconexión tras cambiar **Connect over TCP**, que guarda como mucho los
  últimos 2 segundos para la línea que vuelve a abrirse. Mientras la llamada habla con otra sesión,
  la banda muestra **Talk here**. Si la banda no aparece en una sesión unida, `/live` la
  recupera.
- **El menú de la barra de menús** contiene la llamada, las sesiones unidas (haz clic en una para
  convertirla en el destino), **Load context**, la **Conversation** del destino tal como la
  conserva LiveBridge (con una línea **Task** por cada petición que la voz pasó a Claude y una línea **Loaded context** donde se cargó un resumen), los
  límites de uso, los minutos, **Quick Settings** (elementos con marca de verificación para
  **Connect over TCP**, **Play sounds for requests and answers**, **Notify when a result is waiting**, **Pause sync while the call is stopped** y **Load a session's context on its first call**),
  **Settings…**, **Feedback & Support** (**Report a Bug…** abre el formulario de informe de errores
  del repositorio, **LiveBridge Website** abre getlivebridge.com, **Star LiveBridge on GitHub** abre
  la página del repositorio, y luego **Debug Mode** y **Show Debug Files**, el interruptor y la
  carpeta del [modo de depuración](#ajustes), y **Uninstall LiveBridge…** ([Desinstalación](#desinstalación))) y **Quit LiveBridge**. Quick Settings está ahí incluso cuando el menú
  muestra solo la llamada. Durante una llamada, **Conversation** muestra tus palabras y
  las de la voz a medida que codex las transcribe, así que las tuyas pueden aparecer un momento después
  de decirlas y las de la voz un momento antes de oírlas. Cuando cada frase termina, su texto final
  las sustituye. Solo se conserva el texto final: las palabras que aún lo esperan cuando se cierra la
  línea se pierden.
- **Mute** (junto a **Stop**, en la banda y en la tarjeta de llamada del menú; **Unmute** mientras
  está silenciado) libera tu micrófono mientras la llamada continúa: una respuesta de Claude sigue
  abriendo la línea y pasa a la voz para que la diga. Mientras está
  silenciado, la voz no entrega nada a una sesión: no pudiste pedirlo, así que esa entrega es la voz
  actuando sobre las líneas que recibió, y la app le dice que no se entregó nada. Repítelo tras
  **Unmute**. La banda mantiene la fase y añade `· muted`;
  el menú dice "Muted — line closed" mientras no hay línea abierta. Mute no cierra la línea: una
  línea abierta se cierra tras el silencio habitual, contado desde Mute si estabas hablando, y
  cuando lo habría hecho sin Mute si la línea ya estaba en silencio; se factura como cualquier
  silencio, así que Mute no ahorra minutos de tiempo real. **Unmute** vuelve a tomar el micrófono y,
  si no puede (denegado, ocupado, ausente), la llamada termina con el motivo. **Stop** termina la
  llamada y **Mute**; el siguiente **Start** empieza sin silenciar. Mute no es un cerrojo: cualquier
  proceso que se ejecute como tú puede quitarlo
  ([SECURITY.md](../../SECURITY.md#who-can-drive-the-bridge)).
- **Load context** solo está habilitado cuando a la voz le falta parte del destino: no hay resumen y **Pause sync** impide que la siguiente línea lo cargue o el último pedido falló (hasta el siguiente turno de la sesión o el siguiente Start),
  un turno no llegó, una pregunta o un aviso de permiso no llegó a la aplicación, hubo turnos con el
  mod apagado, las líneas desde el resumen ya no caben en lo que la voz puede llevar (una
  conversación larga lo supera), la sesión estuvo en pausa y tiene resumen, o su mod no sincroniza. En otro caso el
  elemento dice **Context up to date** y está deshabilitado, porque la voz ya tiene la conversación.
  Sin línea abierta, cuando la siguiente línea va a cargar el resumen y no falta nada más, dice **Context loads with the line** y está deshabilitado, porque
  la siguiente línea lo pide sola. Mientras un resumen del destino está en camino, lo haya pedido
  quien sea, dice **Loading context…** y está deshabilitado, como mucho el tiempo que el mod le da ([cuánto](../../docs/architecture/overview.md#its-time); con un mod anterior sigue en **Load context**); uno que llega muestra **Context loaded**
  un momento, y una respuesta vacía vuelve a **Load context**. Un resumen no lleva fecha, así que uno puede ignorarse con el elemento aún habilitado
  ([BR-002](../../docs/bugs/BR-002.md)).
- **New conversation…** borra la conversación del destino y su contexto cargado, y la × de una
  sesión la elimina y borra la suya; ambas preguntan antes. La voz empieza de cero la próxima vez
  que se abre la línea. Los resultados que aún no ha dicho se quedan y se añaden de nuevo; solo
  **Stop** los borra. Las preguntas de Claude en espera siguen otras reglas
  ([detalles](../../SECURITY.md#residual-risk-by-design)). Con **Load a session's context on its first call** activado, o con **Pause sync** desactivado y la sesión sin
  pausa, la siguiente línea carga por sí sola un resumen de la misma transcripción de la sesión, que
  incluye el texto de la conversación (una app y un mod de esta versión dejan fuera la salida de las herramientas, el razonamiento y los recordatorios, pero no el texto que los cita, y uno anterior envía la petición entera); para evitarlo, haz `/clear` en la sesión antes y luego pulsa **New
  conversation**. `/live` en una sesión eliminada la une de nuevo.

### Ajustes

**Settings…** abre la ventana Settings de LiveBridge, en cuatro pestañas en su barra de
herramientas.
**Quick Settings**, en el menú, reúne cinco de sus interruptores ([el menú](#la-banda-y-el-menú)):
cada elemento es el propio ajuste, así que un cambio en un sitio se ve al instante en el otro, y
pregunta lo mismo que el interruptor de aquí.
**General** reúne las notificaciones, el inicio de sesión, las actualizaciones y el modo de
depuración:

- **Notify when a result is waiting** (activado por defecto): junto con el timbre para un resultado
  que espera mientras la línea está cerrada, una notificación de macOS nombra la sesión ("Alpha has
  a new result — speak to hear it"), nunca el resultado en sí. Al hacer clic en ella se abre el
  menú de la barra de menús.
- **Open at login** (desactivado por defecto).
- **Updates**: la versión en uso, **Check for update**, **Check for updates automatically** y lo
  que hizo la última actualización ([Actualización](#actualización)).
- **Debug mode** (desactivado por defecto): durante una llamada, una fila por segundo con los
  números de red de la voz (paquetes perdidos y descartados, jitter, muestras ocultadas, si la línea
  va por TCP), un CSV por llamada, en `~/Library/Application Support/LiveBridge/debug/call-stats/`;
  ni audio, ni transcripción, ni nombres de sesión. Activado durante una llamada, registra la línea
  abierta desde ese momento; desactivado, se detiene al instante, y los archivos quedan hasta que
  los borres. **Show Debug Files** abre la carpeta. En el menú es **Debug Mode**, en **Feedback &
  Support** ([cómo leer los números](../../CONTRIBUTING.md#reading-debug-modes-numbers)).

**Voice** reúne lo que oyes durante una llamada:

- **Voice**: una de las voces en tiempo real que ofrece tu codex, que codex enumera al abrir esta
  pestaña, o **Codex default**. Se oye a partir de la próxima vez que se abre la línea.
- **Prompt** (vacío por defecto): tus propias instrucciones para la voz, como "Háblame en español",
  hasta 2000 caracteres. Se añaden después de las reglas propias de LiveBridge para la voz, que
  prevalecen donde ambas discrepan, y se aplican a partir de la próxima vez que se abre la línea.
- **Play sounds for requests and answers** (activado por defecto): un sonido breve por cada petición que
  la voz pasa a Claude ([por qué](known-limitations.es.md)) y por cada respuesta, fallo o pregunta
  de Claude que llega a una línea abierta o abriéndose mientras nadie habla. El aviso de un
  resultado en espera suena de todos modos.

**Line** reúne cuánto sigue abierta la línea en silencio y cómo se conecta:

- **Silence before the line closes** (20 segundos por defecto), **Wait for a first word on a line
  a result opened** (10 segundos) y **Sound without words before the line closes** (90 segundos):
  cuánto tiempo mantiene abierta la línea cada tipo de silencio, de 0 a 300 segundos. 0 desactiva
  el silencio o el sonido sin palabras, y una espera de primera palabra en 0 dura lo mismo que el
  silencio. Con los tres en 0, el silencio nunca cierra la línea: sigue abierta, facturada todo ese
  tiempo ([Facturación](#facturación-bajo-control-por-diseño)), hasta que pulsas Stop, cambias el
  destino u OpenAI la cierra. Un silencio corto cierra la línea dentro de las pausas normales, y cada
  reapertura tarda unos segundos antes de que la voz responda, así que Settings avisa de 1 a 9
  segundos; lo mismo hace con el sonido sin palabras, pues tu habla cuenta como tal hasta que se
  reconoce, y de 1 a 3 segundos para la primera palabra, ya que la voz suele empezar unos 2 segundos
  después de que la línea se conecta. Un temporizador que activas empieza enseguida en una línea
  abierta en silencio; uno que ya cuenta conserva su tiempo.
- **Connect over TCP** (desactivado por defecto): si la voz se corta con una conexión mala,
  actívalo. La línea prefiere entonces la ruta TCP que ofrece el servidor de medios (el puerto 443
  en las respuestas vistas) a UDP, y aún puede volver a UDP. En una conexión con pérdidas eso puede
  convertir los cortes en pausas breves entre frases ([hasta dónde está probado](known-limitations.es.md)).
  Una línea abierta cuando lo cambias se cierra y se vuelve a abrir en el acto, tras confirmarlo; lo
  que la voz estaba diciendo se corta, y un resultado que la línea esperaba llega igualmente a la
  nueva.

**Context** reúne cómo llegan tus sesiones a la voz:

- **Pause sync while the call is stopped** (desactivado por defecto): por defecto, lo que escribes
  en una sesión unida y la respuesta final de Claude se guardan en la conversación de esa sesión con
  la voz aunque la llamada esté detenida, y la voz los tiene cuando se abre la siguiente línea. Nada
  de ello llega a OpenAI hasta que se abre una línea. Para un texto que no quieres que llegue a OpenAI, activa
  el ajuste, desactiva el siguiente si la sesión puede no tener resumen aún, pulsa Stop y escribe después: nada de lo que escribes con la llamada detenida se
  registra, y la sesión queda marcada como en pausa. Mientras está activado, ninguna línea carga un
  resumen por sí sola, ni tampoco después de una pausa, salvo para una sesión sin resumen (el ajuste
  siguiente); si no, solo lo hace **Load context**. Ese resumen se escribe a partir de la transcripción, así que lleva lo que pausaste. Escribir en un turno que ejecuta una petición por voz hace fallar su respuesta, sin que
  nada de ella se registre ni se diga. No elimina nada ya registrado, y las respuestas posteriores
  de Claude pueden repetir el texto en pausa; qué hace y qué no hace lo explica
  [SECURITY.md](../../SECURITY.md#residual-risk-by-design).
- **Load a session's context on its first call** (activado por defecto; desactivado si **Pause sync** estaba activado al actualizar):
  Start, un cambio de destino durante la llamada o una línea que se abre, para una sesión de la que
  la voz no tiene resumen, lo pide aunque **Pause sync** esté activado o la sesión esté en pausa,
  también en un chat antiguo o tras **New conversation**. Ese resumen se escribe a partir de la transcripción, así que lleva lo que pausaste, y va a
  OpenAI. Cuando la sesión ya tiene resumen, la pausa rige lo que sigue.
  Desactivado, bajo la pausa solo **Load context** carga un resumen.
- **Summary model** (Haiku 5.5 por defecto, también al actualizar; o Sonnet 5.5, Opus 5.5 o **Custom…**): el
  modelo que escribe el resumen que la voz recibe como contexto, siempre con esfuerzo bajo, a cargo
  de tu uso de Claude. Si otro modelo falla, lo escribe Haiku 5.5, salvo que a ese modelo se le acabara el tiempo. Una línea debajo dice cuándo el
  último resumen vino de Haiku 5.5, o de ningún modelo, y por qué. Una sesión con un mod anterior a
  este ajuste lo ignora y escribe con el modelo propio de la sesión. **Custom…** toma un id de
  modelo y **Check and save**, que hace que una sesión unida envíe a ese modelo una petición corta
  ("Reply with OK.") a cargo de tu uso de Claude, y guarda el id solo si responde; si no, el motivo
  aparece junto al campo y la elección anterior sigue. Necesita una sesión con un mod de esta
  versión y habla por el Claude Code de esa sesión: otra sesión puede diferir, y un id guardado no
  se vuelve a comprobar.

### Qué hace la voz

- Responde ella misma a la charla trivial y a las explicaciones, y pasa todo lo que necesita el
  repositorio o la sesión: tareas, preguntas sobre el código, decisiones, correcciones y
  detenciones.
- Antes de pasar algo destructivo o dirigido al exterior (borrar, hacer push, publicar, enviar,
  desplegar, pagar), repite la petición y pregunta "¿sí?". Es un hábito que se le indica a la voz
  mantener, no una salvaguarda; [SECURITY.md](../../SECURITY.md) explica qué sí lo es.
- Lee los resultados en una o dos frases, con el nombre de la sesión. Los bloques de código y las
  tablas se quedan en la sesión, y las credenciales que reconoce se ocultan.
- Vuelve cuando Claude termina. No hace falta mantener la línea abierta: se cierra cuando la
  conversación se calla, y la respuesta de Claude a tu petición vuelve a abrirla y se da a la voz
  para que la diga, así que puedes irte mientras Claude trabaja. Esto vale para la sesión con la que
  hablas; un resultado de otra sesión suena con un timbre y queda en espera ([cómo se
  factura](#facturación-bajo-control-por-diseño)). Si la voz se queda callada en la línea reabierta,
  la respuesta también suena con un timbre y queda en espera, así que no se pierde. Una pregunta que
  Claude te hace o una solicitud de permiso que espera abre la línea igual, pero la voz puede no
  decirla: no confíes en ello cuando estés lejos del Mac ([limitaciones
  conocidas](known-limitations.es.md)).
- Cuando Claude hace una pregunta, se da a la voz para que te la plantee, y tu respuesta vuelve a
  esa sesión. Lo mismo ocurre con una pregunta que Claude plantea mientras trabaja (el diálogo con
  opciones): la voz la recibe para hablarte de ella, explicar las opciones con sus propias palabras
  y comentarlas contigo todo el tiempo que quieras, sin preguntar a Claude. Lo que decidas, una
  opción o una pregunta de vuelta a Claude, responde al diálogo; también puedes responderlo en el
  teclado. El trabajo que Claude termina más tarde en segundo plano pasa a la voz como una
  actualización.
- Cuando Claude está esperando una solicitud de permiso, la voz recibe un aviso y puede decirlo,
  salvo [donde una organización administra Claude Code](known-limitations.es.md). Tú respondes a la
  solicitud en Claude Code; LiveBridge nunca la responde por ti.
- Recibe lo que escribes. Mientras una sesión está unida, lo que escribes en ella y la respuesta
  final de Claude a cada turno que no fue una petición por voz pasan a la conversación de esa sesión
  con la voz como contexto: no suena ningún aviso por ellos ni abren una línea cerrada ([los límites
  de esto](known-limitations.es.md)). Una línea abierta los recibe de inmediato; una línea que se
  abre después empieza con ellos. Una respuesta por voz que una petición más nueva desplazó no se
  dice, pero se guarda y se añade igual. El texto de Claude a mitad de turno no se sincroniza, salvo
  lo que escribió justo antes de una pregunta o una solicitud de permiso, que va con ella; los
  subagentes y la salida de las herramientas tampoco. Una pregunta o una solicitud de permiso en el
  destino se da a la voz, sea cual sea el turno que la causó; en otra sesión va como iría un
  resultado de ella, salvo que la de un turno que no fue una petición por voz solo se registra. Un
  turno que la pausa deja fuera no tiene nada de esto. Cuando una pregunta o una solicitud se
  resuelve sin la voz, o un turno termina sin respuesta, la voz recibe una línea que lo dice ([qué
  líneas](../../SECURITY.md#what-session-text-can-do)).

## Facturación bajo control por diseño

Una sesión de voz en tiempo real cuesta mientras está abierta, así que LiveBridge la abre solo
mientras alguien habla, mientras todavía puede llegar la respuesta de Claude a una petición que
acabas de hacer, o para decir esa respuesta, una pregunta de Claude o que Claude espera tu
permiso:

- Mientras hay una llamada en curso y nadie habla, el micrófono alimenta únicamente un detector de
  voz en tu Mac. No se envía audio a ninguna parte.
  Mientras está silenciado, LiveBridge no tiene el micrófono, y el indicador de micrófono de macOS lo muestra.
- Cuando empiezas a hablar, se abre la línea. Los 2 segundos anteriores a que empezaras se
  conservan y se envían primero, para que no se pierdan tus primeras palabras.
- La línea se cierra tras un rato de silencio, y el sonido sin palabras (música, una tele) la cierra
  tras un rato propio. [Ajustes](#ajustes) fija cada uno; en 0, ese no la cierra.
- Cuando la voz pasa una petición a Claude (un traspaso), la línea permanece abierta hasta 2 minutos
  después de ese traspaso, facturada como cualquier línea abierta, y la respuesta de Claude pasa a
  la voz para que la diga cuando nadie esté hablando. Un traspaso posterior reinicia los 2 minutos;
  un intercambio que no envía nada a Claude se cierra tras el silencio habitual.
- La respuesta de Claude a una petición que le diste a la sesión con la que hablas, una pregunta que
  Claude te hace en ella o una solicitud de permiso que espera vuelve a abrir la línea si llega con
  la línea cerrada, y se da a la voz para que la diga, con el coste de cualquier línea abierta. Todo
  lo demás que llega con la línea cerrada (cualquier cosa de una sesión de la que cambiaste, una
  actualización posterior) reproduce un timbre y queda en espera: la banda y el menú lo muestran
  como sin escuchar, y pasa a la voz la próxima vez que hables ([cuándo se considera
  escuchado](../../docs/architecture/overview.md#a-result-while-the-line-is-closed)).
- Cada sesión de Claude Code tiene su propia conversación con la voz. Se traslada a la siguiente
  sesión en tiempo real, y a través de Stop y Start, de modo que la voz recuerda lo que dijiste hace
  un minuto. Un nuevo destino cambia la conversación: una línea abierta se cierra, y tus siguientes
  palabras la abren con la conversación del nuevo destino.
- El menú muestra los minutos que la línea estuvo abierta, contados por la aplicación desde que la
  voz se conecta, así que tu plan puede contar algo más. OpenAI cobra la voz de escritorio por
  minuto de tu presupuesto de uso de Codex, y en su API la misma familia de modelos factura también
  el silencio ([detalles](../../docs/research/2026-11-04-gpt-live-billing.md),
  [límites](../../docs/research/2026-11-05-gpt-live-limits.md)); la página de uso de tu plan es la
  autoridad.
- El menú muestra cuánto de tu uso de Codex y de Claude se ha gastado, una fila cada uno, como
  porcentaje usado de cada ventana que informa el plan (hasta tres por fila, por ejemplo
  `7% of 5 h · 19% of week`), en naranja desde el 90 %; pasa el cursor sobre una fila para ver
  cuándo se reinicia cada ventana. Las cifras de Codex se leen cada vez que se abre el menú, como
  máximo una vez por minuto, con un codex de corta vida; las de Claude llegan de una sesión unida
  cuando ya ha respondido. Una fila sin nada que mostrar se omite, y la de Codex dice `blocked`
  cuando codex informa de que el uso ordinario no está permitido. La última lectura de Codex se
  muestra enseguida y una nueva la sustituye unos segundos después, así que las cifras pueden cambiar
  con el menú abierto; justo tras el arranque la fila aparece cuando llega la primera lectura, y si
  las lecturas fallan, una lectura desaparece a los 15 minutos. Qué límite detiene primero la
  voz no está documentado ([detalles](../../docs/research/2026-11-05-gpt-live-limits.md)).

## Actualización

LiveBridge actualiza la aplicación y su mod cuando pulsas **Install**, y nunca por su cuenta. Solo
se actualiza la copia en `/Applications/LiveBridge.app`; cualquier otra copia lo indica en
Settings.

- **Check for updates automatically**, en Settings (activado por defecto, desactivado en una
  compilación desde el código fuente): una vez al día, la aplicación pregunta a GitHub cuál es la
  última versión. Una más reciente se anuncia una sola vez, con una notificación cuyo **Install**
  la instala, y el menú de la barra de menús ofrece **Install LiveBridge X.Y.Z…** hasta que se
  instala, para lo cual vuelve a preguntar a GitHub en cada arranque. **Check for update**, en
  Settings, pregunta en el momento.
- **Install** necesita la [GitHub CLI](https://cli.github.com) con la sesión iniciada
  (`gh auth login`); sin ella, Install no descarga nada y enlaza a la página de la versión.
  Descarga la imagen de la versión, la comprueba con el mismo `gh attestation verify` que muestra
  [Desde la imagen de disco](README.es.md#desde-la-imagen-de-disco),
  después comprueba la aplicación que contiene, y no instala nada a menos que se superen todas las
  comprobaciones. Espera mientras Claude siga con una petición de voz, actualiza el mod con
  `claude plugin marketplace update livebridge` y `claude plugin update livebridge@livebridge`,
  detiene la llamada, pone la aplicación nueva en su sitio en un solo paso y la abre.
- Después, Settings indica desde qué versión se actualizó. Si no se pudo actualizar el mod,
  muestra esos dos comandos para que los ejecutes tú. Las sesiones de Claude Code ya abiertas
  conservan el mod antiguo hasta que se reinician; Settings lista las unidas que aún lo usan.
- La descarga de la actualización no pone el atributo de cuarentena, así que macOS no debería
  detener el primer arranque de la aplicación actualizada para preguntar, como hizo tras la primera
  descarga; esto se deduce del código y aún no se ha observado. Las comprobaciones de arriba
  ocupan ese lugar ([SECURITY.md](../../SECURITY.md#what-an-update-installs)). Las versiones
  posteriores a 0.4.2 se firman con el Developer ID de LiveBridge, así que el permiso del
  micrófono debería pasar de una a la siguiente; esto se deduce de cómo macOS asocia el permiso y
  aún no se ha observado. La 0.4.2 y las anteriores se firmaron ad hoc, así que la
  primera actualización desde una de ellas vuelve a pedir el micrófono una vez, en el primer
  **Start**.

Para actualizar a mano, ejecuta `/live off` en todas las sesiones (el mod vuelve a abrir la
aplicación de `/Applications` en cuanto deja de responder), cierra LiveBridge, instala la imagen
más reciente como indica [Instalación](README.es.md#instalación) y ejecuta los dos comandos
`claude plugin`.

## Desinstalación

En la copia de `/Applications`, **Feedback & Support ▸ Uninstall LiveBridge…**, en el menú,
pregunta primero y mueve la app a la Papelera; si no puede, lo dice, deja la app donde está y vuelve a poner el inicio de sesión que haya quitado antes, y si macOS no le deja volver a ponerlo, también lo dice, y cómo volver a activar **Open at login**. Luego termina la llamada abierta y cada sesión deja LiveBridge, como con la ×
del menú, así que `/live` se apaga en ella en vez de volver a abrir LiveBridge; LiveBridge quita
el inicio de sesión y el permiso del micrófono y se cierra, y una vez cerrado, los archivos que
guarda (los de abajo) van a una carpeta de la Papelera, hasta que la vacíes. Deja
el mod de Claude Code y copia el comando que lo quita, `claude plugin uninstall livebridge@livebridge`,
para que lo ejecutes en Terminal. Una sesión que no estaba abierta entonces puede volver a
buscar LiveBridge cuando se abra; quitar el mod lo termina.

¿Lo instalaste con Homebrew? `brew uninstall --cask getlivebridge/tap/livebridge` quita la app y el registro de Homebrew;
los pasos de abajo siguen siendo para los archivos que guarda la app.

Desde un clon, `scripts/build-app.sh --uninstall` elimina `/Applications/LiveBridge.app`, sea cual
sea la forma en que se instaló, su elemento de inicio de sesión y todos los archivos que conserva, e
imprime los dos comandos que deja de tu mano: `tccutil reset Microphone com.getlivebridge.livebridge`
y `claude plugin uninstall livebridge@livebridge`.

Sin un clon, desactiva **Open at login** en los Ajustes de LiveBridge, cierra LiveBridge y ejecuta
los mismos pasos en Terminal:

```sh
rm -rf /Applications/LiveBridge.app ~/Library/Application\ Support/LiveBridge \
  ~/Library/{Caches,WebKit}/com.getlivebridge.livebridge \
  ~/Library/HTTPStorages/com.getlivebridge.livebridge{,.binarycookies} \
  ~/Library/Preferences/com.getlivebridge.livebridge.plist
tccutil reset Microphone com.getlivebridge.livebridge
claude plugin uninstall livebridge@livebridge
```

Ninguna de estas formas elimina una copia llamada `/Applications/.LiveBridge-update-….app`, que
puede dejar una actualización interrumpida a mitad de la instalación. La aplicación elimina esas
copias en su siguiente arranque; tras desinstalar, bórrala a mano si existe.

`claude plugin uninstall` puede dejar la instantánea del mod,
`~/.claude/plugins/store/livebridge_*.json`: la documentación de Claude Code sobre lo que borra no
nombra ese archivo, y esto no se ha ejecutado. Bórralo a mano si está ahí.
