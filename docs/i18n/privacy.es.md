# Privacidad

*El texto en inglés es el canónico ([privacy.md](../privacy.md)); esta traducción puede ir por detrás.*

Qué llega a OpenAI y a GitHub, y qué guarda LiveBridge en tu Mac. El [README](README.es.md#privacidad)
tiene el resumen, y [SECURITY.md](../../SECURITY.md) el modelo de amenazas.

LiveBridge no tiene telemetría ni escucha en ningún puerto de red; el mod habla con la aplicación
por un socket Unix en una carpeta que solo tu usuario puede abrir. Lo que va a OpenAI, a través de
la sesión en tiempo real de codex:

- el audio del micrófono mientras la línea está abierta, desde 2 segundos antes de que empezaras a
  hablar (o, en una línea que abrió una respuesta, pregunta o solicitud de permiso de Claude, desde
  que se abrió) hasta que se cierra (con Mute, LiveBridge no capta nada, así que no sale audio; lo
  que dijiste antes de pulsar Mute, en una línea que ya se estaba conectando, puede salir
  igualmente);
- las instrucciones de la voz: las reglas propias de LiveBridge y, después, el **Prompt** de tus
  Ajustes si escribiste uno;
- la conversación reciente de la sesión de destino (hasta las últimas 64 líneas, y no más de lo que
  admite codex: 128 elementos y unos 8192 tokens con el contexto y las tareas abiertas) para
  continuarla en una nueva sesión en tiempo real. Incluye lo que escribiste en esa sesión y la
  respuesta final de Claude a cada turno que no fue una petición por voz, lo iniciara lo que lo
  iniciara (un turno que escribiste, una tarea programada, otro agente, una tarea en segundo plano),
  además de las notas del mod, tu voz y la de la voz, así que escribir en una sesión lo envía a
  OpenAI cuando se abre una línea con ella. Mientras una línea está abierta, cada línea nueva del
  destino entra de inmediato. Las líneas sincronizadas de otra sesión solo salen cuando se abre una
  línea con ella como destino; sus resultados, preguntas y avisos de aprobación entran en la línea
  abierta sea cual sea la sesión;
- las peticiones de la sesión de destino aún abiertas, como sus resúmenes de una línea;
- cada resultado, pregunta, actualización, aviso de aprobación, texto escrito, respuesta a un turno
  que no fue una petición por voz, respuesta por voz que una petición más nueva desplazó y nota del
  mod, como una línea de como máximo 2000 caracteres, sin bloques de código ni tablas (un texto
  escrito que es solo código o una tabla se sustituye por una frase que dice que se escribió
  código). Las notas del mod nombran la herramienta de una solicitud de permiso permitida o
  resuelta, y dicen que se cerró una pregunta o que un turno terminó sin respuesta. Una pregunta que
  Claude hace a mitad de turno, y el aviso de aprobación de un permiso que pide el bucle principal
  de Claude (no un subagente), llevan también lo que Claude escribió justo antes de pedirlo. Una
  actualización es la respuesta de Claude en un turno posterior iniciado por la notificación de una
  tarea en segundo plano, durante hasta 10 minutos después de una petición por voz y hasta que
  empiece cualquier otro turno en la sesión;
- el resumen de contexto de la sesión de destino, como una línea de como máximo 1500 caracteres. Se
  guarda cuando se carga y se envía cada vez que se abre la línea mientras esa sesión es el
  destino, a través de Stop y Start y de los reinicios de la aplicación. El submenú Conversation del
  menú muestra esa línea exactamente como se envía;
- con cada línea anterior, la etiqueta de su sesión: el título de la sesión de Claude Code (hasta 80
  caracteres) o, si no tiene, el nombre de la carpeta de la sesión. La etiqueta no se oculta y la
  pausa no la toca, así que un título escrito a partir de texto en pausa sale en cada línea;
- la oferta WebRTC, que enumera las direcciones de red local del Mac como candidatas de conexión.

Con **Connect over TCP** activado, el audio sigue yendo al servidor de medios de OpenAI, y puede ir
por TCP (el puerto 443 en las respuestas vistas) en lugar de UDP.

Los resultados, las preguntas, las actualizaciones, los resúmenes y las líneas de los turnos escritos pasan antes por un redactor de
formatos de credenciales conocidos (claves privadas, JWT, tokens de API comunes, contraseñas en
URL, campos del tipo `password=`). Es una lista de patrones, no una garantía: todo lo demás que escribes sale tal cual.

El hilo de codex que transporta la voz es efímero y de solo lectura, con todas las funciones de
codex desactivadas salvo donde conserva tu inicio de sesión y cómo usa tu proxy, y con todos los
servidores MCP desactivados; está ahí solo para conversar. El trabajo de Claude va a Anthropic como
siempre lo hace tu sesión de Claude Code.

Al abrir el menú, LiveBridge inicia un codex de corta vida que pregunta a OpenAI, con tu inicio
de sesión de ChatGPT, cuánto de tu uso de Codex se ha gastado (el porcentaje y la hora de reinicio
de cada ventana). Ocurre como máximo una vez por minuto, también con la llamada apagada, y no
envía audio ni texto. Las cifras de Claude llegan a la aplicación desde el mod por el socket y no
van a ningún otro sitio; la aplicación guarda ambas solo en memoria.

Para las actualizaciones, la aplicación se comunica con GitHub. Con **Check for updates
automatically** activado, una vez al día (y en cada arranque mientras no se haya instalado una
versión que anunció) pregunta a la API de GitHub, sin credenciales, cuál es la última versión;
GitHub ve la dirección IP de tu Mac. **Check for update**, en Settings, envía la misma petición
cuando lo pulsas. Cuando la comprobación automática encuentra una versión más reciente, la
aplicación ejecuta `gh auth status` para indicar si la imagen se puede verificar. Solo cuando
pulsas **Install** descarga la imagen y ejecuta `gh attestation verify` y `claude plugin`, que se
conectan a GitHub, y a Sigstore para la raíz de confianza de `gh`, con tus propios inicios de sesión.
[SECURITY.md](../../SECURITY.md#what-leaves-the-mac) enumera cada petición.

En tu Mac, la aplicación guarda sus ajustes, el contador de uso, cuándo buscó actualizaciones por
última vez y qué versiones anunció, lo que hizo la última actualización y, para cada una de las
últimas 20 sesiones usadas, su conversación reciente (hasta 64 líneas, con lo que escribiste en ella; se registra sin llamada
salvo que actives **Pause sync**) y la última línea de contexto cargada desde ella, en `~/Library/Application Support/LiveBridge`, una carpeta que solo tu usuario puede abrir
([cómo se guarda](../../SECURITY.md#residual-risk-by-design)). Las líneas de una sesión desaparecen cuando
pulsas **New conversation** con ella como destino o la eliminas con la ×. Una sesión que se ha ido
las conserva hasta que 20 sesiones usadas después las desplazan; para borrarlas antes, ejecuta
`/live` en ella de nuevo y pulsa **New conversation**. La desinstalación las elimina todas; Uninstall LiveBridge, en el menú, las mueve a la
Papelera, y desaparecen cuando la vacías. El mod guarda una instantánea propia en el almacén de plugins de Claude Code ([qué contiene](../../SECURITY.md#residual-risk-by-design)).
**Debug mode**, desactivado por defecto, escribe los números de red de la voz durante una llamada
en un archivo de esa carpeta, y nada más ([Ajustes](guide.es.md#ajustes)).
