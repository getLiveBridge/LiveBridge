# Limitaciones conocidas

*El texto en inglés es el canónico ([known-limitations.md](../known-limitations.md)); esta traducción puede ir por detrás.*

Lo que LiveBridge no hace, o hace solo en parte, con el registro detrás de cada punto medido. El
[README](README.es.md#limitaciones-conocidas) tiene el resumen, y [guide.es.md](guide.es.md) los
ajustes que se nombran aquí.

- **Connect over TCP** prefiere TCP pero no lo impone, y nada muestra durante la llamada qué transporte tomó
  una línea, así que una línea que volvió a UDP aún puede cortarse. La ruta se midió una vez, en
  una compilación de depuración que quitaba los candidatos UDP (ningún audio perdido en 10
  minutos); la forma que se distribuye, bajar su prioridad, eligió TCP una vez. El modo de
  depuración registra el transporte (`onTcp`) ([CONTRIBUTING.md](../../CONTRIBUTING.md#reading-debug-modes-numbers)).
- A veces la voz dice que está mirando ("On it", "Looking now") sin pasar la petición, así que a
  Claude no le llega nada: más o menos una petición de cada cinco con la regla tal como se escribió
  primero, y 0 de 20 con la regla actual, muy pocas para distinguirlo de la suerte
  ([BR-001](../../docs/bugs/BR-001.md)). También puede afirmar un trabajo que no ha hecho, como en "I'll
  take a look.", incluso a partir de líneas que solo tiene como contexto ([ADR 0001 (n),
  (o)](../../docs/adr/0001-platform-findings.md)). La aplicación emite un sonido breve cuando pone una
  petición en la cola de Claude, distinto del de una respuesta; si la voz dice que está mirando y
  ese sonido no llega, repite la petición. La aplicación no puede distinguir esa promesa de una respuesta por sus palabras, porque
  la voz habla tu idioma.
- Una pregunta de Claude, o una solicitud de permiso que espera, solo se da a la voz, y la voz puede
  no decirla; nada la obliga. Por eso no confíes en que la voz anuncie una solicitud cuando estés
  lejos del Mac: Claude puede quedarse esperando sin aviso. La solicitud sigue esperando en Claude
  Code, y es el único control; la voz no es un control, y LiveBridge nunca responde a la solicitud.
  En las comprobaciones, el aviso de permiso de un turno escrito, con la línea abierta, se dijo
  antes de la respuesta en el teclado en 0 de 3 ejecuciones, un recuento y no una tasa ([ADR 0001
  (n)](../../docs/adr/0001-platform-findings.md)). Una línea cerrada se abre para ellas solo si la
  conversación del destino tiene un turno tuyo; si no, la aplicación suena un timbre, y con la
  llamada apagada solo se registra.
- Un resultado que llega mientras la línea lo espera pasa a la voz como texto para decir; codex no
  tiene ninguna llamada que haga hablar a la voz de inmediato, así que el modelo decide cuándo. La
  prueba de humo de extremo a extremo ([scripts/smoke.sh](../../scripts/smoke.sh)) comprueba que la
  voz dice ese resultado antes de tus siguientes palabras; no se midió cuánto tarda en hablar. Si no
  lo hace, el resultado queda sin escuchar: vuelve a
  pasar a la voz con tus siguientes palabras, o suena un timbre cuando se cierra la línea.
- Cuando la respuesta de Claude vuelve a abrir la línea, la voz puede quedarse callada: ocurrió en 4
  de 14 ejecuciones medidas, una muestra pequeña ([ADR 0001
  (n)](../../docs/adr/0001-platform-findings.md)). La línea se cierra entonces cuando
  termina su espera de una primera palabra ([Ajustes](guide.es.md#ajustes)), y la respuesta suena con un timbre y
  queda en espera, como abajo. Cuando la voz habló, empezó en unos 2 segundos tras la conexión; una
  voz que empezara después de esa espera queda cortada.
- Cuando tus siguientes palabras reabren la línea, a veces la voz responde solo a ellas y no dice el
  resultado en espera. El resultado no se pierde: sigue esperando, suena un timbre y publica una
  notificación cuando se cierra la línea, y vuelve a pasar a la voz la próxima vez que se abre la
  línea.
- Al llegar al límite de uso de tu plan de ChatGPT, la voz se detiene hasta que el límite se
  reinicia. El menú y la banda lo dicen, con la frase de codex y su hora de reinicio cuando codex la
  da, y la llamada termina, para que hablar no abra líneas que fallan. Claude Code sigue trabajando,
  las respuestas siguen esperando y Start lo intenta una vez más. La aplicación reconoce un límite
  solo por la redacción de codex o el código de error del servicio, porque nada más lo comunica
  ([detalles](../../docs/research/2026-11-05-gpt-live-limits.md)). Un rechazo que no reconoce, como una
  línea que cae sin motivo indicado ("The voice session closed (transport_closed)."), deja la
  llamada activa, así que tus siguientes palabras lo vuelven a intentar; pulsa **Stop** hasta que el
  límite se reinicie.
- Un prompt que no se escribe en el compositor (el mensaje de un host, una tarea programada, otro
  agente y presumiblemente Remote Control) no se registra en la conversación de la voz como palabras
  tuyas, aunque sí la respuesta de Claude, y no rechaza un turno en curso bajo la pausa
  ([SECURITY.md](../../SECURITY.md#what-session-text-can-do) dice qué prompts cuentan como tuyos).
- Donde el proveedor de Claude Code (Bedrock, Vertex o Foundry) no ofrece el modelo elegido en
  **Summary model**, o la organización no lo permite, ese modelo falla y Haiku 5.5 escribe el
  resumen; donde tampoco ofrece Haiku 5.5, la voz no recibe resumen, y Settings lo dice. Antes de
  este ajuste lo escribía el modelo propio de la sesión, que funciona dondequiera que funcione la
  sesión. Que un id fijo se resuelva en esos proveedores viene de la documentación de Claude Code y
  no se ha probado.
- Una sesión que sigue con un mod anterior a esta versión, hasta que se reinicie, no se sincroniza:
  carga un resumen como una sesión a la que le faltan turnos, y ninguna pausa rechaza sus líneas
  ([qué más cambia](../../CHANGELOG.md)).
- Una sesión de Claude Code que ya estaba abierta antes de que se cargara el mod puede necesitar
  reabrirse para que `/live` funcione en ella.
- En la aplicación de escritorio de Claude, `/live` escrito en una sesión cuyo proceso de Claude Code
  aún no ha arrancado (una sesión nueva o recién reabierta) puede mostrar "/live isn't a command
  here." El comando se ejecuta igualmente. La aplicación de escritorio obtiene los comandos de esa
  sesión de una comprobación que ejecuta con los hooks desactivados, por lo que el código del mod,
  que declara `/live`, no se ejecuta ahí; una vez que la sesión está en marcha, la aplicación de
  escritorio toma la lista de la propia sesión. El mod no tiene arreglo para esto: un archivo de
  comando estático se listaría como `/livebridge:live`, no como `/live`, y con los hooks
  desactivados enviaría su texto al modelo en lugar de ejecutar el mod.
- Si una respuesta ha dicho un resultado en espera se juzga por sus palabras, con una lista de
  palabras comunes solo en inglés y ruso
  ([la regla](../../docs/architecture/overview.md#a-result-while-the-line-is-closed)). En otro idioma, un
  resultado puede contar como escuchado cuando la voz solo lo ha mencionado.
- Donde una organización administra Claude Code, nada en LiveBridge te avisa de que hay una
  solicitud de permiso esperando. El guardián integrado de Claude Code se carga en un equipo con
  ajustes administrados y en una sesión iniciada con un plan Team o Enterprise, y ahí los hooks de
  permisos del mod no se ejecutan. La solicitud sigue apareciendo en Claude Code y sigue
  esperándote, pero la voz no dice nada de ella y el menú muestra a Claude trabajando,
  así que mira Claude Code si una respuesta parece tardar. `/plugin` nombra los hooks, y las
  versiones recientes de Claude Code también imprimen una línea que dice que un hook se omitió.
  Las preguntas de Claude siguen llegando a la voz. Los hooks se
  [midieron](../../docs/adr/0001-platform-findings.md) en un contenedor Linux; lo que hacen la voz y la
  barra de menús se deduce del código, y no se probó una línea real. El caso de Team y Enterprise
  viene de la documentación de Claude Code.
- Con `allowManagedHooksOnly`, `allowManagedModsOnly` o `disableAllHooks` en los ajustes
  administrados, el mod no se carga y `/live` no funciona. Un administrador puede [instalar el mod
  como propio de la
  organización](https://code.claude.com/docs/en/plugins/mods/admin#install-your-organizations-mods),
  desde una carpeta en cada equipo: entonces los hooks de permisos se ejecutan, también con los
  dos primeros ajustes ([medido](../../docs/adr/0001-platform-findings.md)). Según la documentación de
  Claude Code, activar la copia del marketplace en los ajustes administrados no basta.
