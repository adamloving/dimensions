var Router = {
	_currentModule: null,
	LastRequest: null,
	controlllers: null,
  getController : function(name)
	{
		name = ucfirst(name);
		
		if (this.controllers == null)	this.controllers = new Array();
		
    if (this.controllers[name] === undefined)
		{
			controllerName = name + 'Controller';
			this.controllers[name] = eval ('new ' + controllerName);
			
			if ($.isFunction(this.controllers[name].init))
			{
				this.controllers[name].init();
			}
		}
		
		return this.controllers[name];
  },
  setCurrentModule: function (name)
	{
		Router._currentModule = name;
	},
	getCurrentModule: function ()
	{
		return Router._currentModule;
	},
	getCurrentController: function ()
	{
		return Router.getController(Router.getCurrentModule());
	},
	handleRequest: function (event, defaultAddr)
	{
		Request = new AddressRequest (event, defaultAddr)
		Router.LastRequest = Request;
		Request.dispatch();
	},
	refresh: function ()
	{	
    if (Router.LastRequest != null) Router.LastRequest.dispatch();
    //Router.LastRequest.dispatch();
	}
}

/**
 * Despacha a una clase/metodo una peticion basado en una URL
 * obtenida por el plugin jquery address:
 * http://www.asual.com/jquery/address/
 * Acepta una URL por defecto
 * Ej: La URL estados/ciudades sera despachada a
 * EstadosController.ciudadesAction(Dispatcher)
 * Se envia la clase Dispatcher como parametro de la funcion
 * La cual contendra informacion del evento (this.event)
 * De la URL (this.Url) y otros
 * El constructor UrlHelper es requerido
 * @param event puede ser un evento de jquery address o directamente una URL
 * @param defaultAddr URL por defecto si no es pasada ninguna
 */
function AddressRequest(event, defaultAddr)
{
	if (event.value != undefined)
	{
		// Evento del plugin jquery address
		this.event = event;
		
		url = this.event.value;
	}
	else
	{
		url = event;
	}
	
	// determinamos la direccion que sera usada para invocar la peticion
	//puede ser defaultAddr
	addr = url.replace(/^.*#/, '');
	if (addr == '/' || addr == '')	addr = defaultAddr;

  // Utilizamos el Helper Url para determinar el controlador y la accion
	// que debemos invocar
	this.Url = new UrlHelper(addr);
	this.strController = ucfirst(this.Url.module) + 'Controller';
	this.strAction = this.Url.action + 'Action';
	
	// Metodo para despachar la accion correspondiente
	// Como parametro se envia una referencia a AddressDistpacher
	this.dispatch = function ()
	{
		var Controller = Router.getController(this.Url.module);
		
		Router.setCurrentModule(this.Url.module);

		var func = Controller[this.strAction];

		if (typeof func === 'function')
		{
			if ($.isFunction(Controller.preExecute))
			{
				Controller.preExecute(this);
			}
			
			func.call(func, this);
		}
		else
		{
			throw new Error(this.strController + '.' + this.strAction + ' no es una funcion valida');
		}
	}
}

/**
 * Divide y almacena informacion a partir de una cadena que contenga una URL
 * La url debe tener uno de estos formatos:
 * - module/action
 * - module/action/param1/value1/.../paramN/valueN
 */
function UrlHelper(url)
{
	var that = this;
	
	url = url.replace(/^[/]/,'').replace(/[/]$/,'');
	
	// almacena la url completa
	this.url = url;

	// divide la URL en segmentos para poder procesarla
	segments = url.split('/');

	// almacena el nombre del modulo (primer segmento)
	this.module = segments.shift();
	
	// almacena el nombre de la accion (segundo segmento)
	this.action = segments.shift();
	
	if (this.action == null) this.action = 'index';
	
	// lo siguiente se ocupa de procesar los parametros faltantes
	// tal como lo hace symfony con los wildcar (*)
	this.params = new Object;
	
	key = null;
	
	for (i in segments)
	{
		if (key == null)
		{
			key = segments[i];
		}
		else
		{
			this.params[key] = segments[i];
			key = null;
		}
	}
	
	this.getUrl = function ()
	{
		return that.url;
	}
	
	this.getUrlForPag = function ()
	{
		return that.getUrl().replace(/\/page\/\d+/, '');
	}
	
	this.getModule = function () {return that.module;}
	this.getAction = function () {return that.action;}
	this.getParams = function () {return that.params;}
	
	this.getParam = function (name)
	{
		return that.params[name] != undefined ? that.params[name] : null;
	}
	
	this.hasParam = function (name)
	{
		return that.params[name] != undefined;
	}
}

/**
 * http://phpjs.org/functions/ucfirst:568
 */
function ucfirst (str)
{
	str += '';
	var f = str.charAt(0).toUpperCase();
	return f + str.substr(1);
}
