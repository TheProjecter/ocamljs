(*
 * This file is part of ocamljs, OCaml to Javascript compiler
 * Copyright (C) 2007 Skydeck, Inc
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free
 * Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
 * MA 02111-1307, USA
 *)

module Common =
struct
  class type uRI =
  object
    method _get_spec : string
    method _set_spec : string -> unit
    method resolve : string -> string
  end
end

module DOM =
struct
  (* XXX do these fall into some more sensible hierarchy than element -> everything else? *)

  class type style =
  object
    method _get_display : string
    method _set_display : string -> unit
    method _get_visibility : string
    method _set_visibility : string -> unit
  end

  class type eventTarget =
  object
  end

  class type event =
  object
    method _get_bubbles : bool
    method _get_cancelable : bool
    method _get_eventPhase : int
    method _get_target : eventTarget
    method _get_timeStamp : float
    method _get_type : string

    method initEvent : string -> bool -> bool -> unit
    method preventDefault : unit
    method stopPropagation : unit
  end

  class type element =
  object
    method addEventListener : string -> (event -> unit) Ocamljs.jsfun -> bool -> unit
    method removeEventListener : string -> (event -> unit) Ocamljs.jsfun -> bool -> unit
    method getAttribute : string -> 'a
    method setAttribute : string -> 'a -> unit
    method dispatchEvent : #event -> unit
    method _get_hidden : bool
    method _set_hidden : bool -> unit
    method _get_style : style
    method _get_innerHTML : string
    method _set_innerHTML : string -> unit
    method _get_innerText : string
    method _set_innerText : string -> unit
  end

  class type abstractView =
  object
  end

  class type xPathResult =
  object
    method iterateNext : 'a
    method _get_singleNodeValue : 'a
    method _get_ANY_TYPE : int
    method _get_FIRST_ORDERED_NODE_TYPE : int
    method _get_ORDERED_NODE_ITERATOR_TYPE : int
  end

  class type document =
  object
    (* XXX do better *)
    method evaluate : string -> document -> 'namespaceResolver -> int -> #xPathResult -> xPathResult

    method createEvent : string -> #event

    method _get_defaultView : abstractView

    method getElementById : string -> 'a
    method _get_location : string
    method _set_location : string -> unit
  end

  class type a =
  object
    inherit element
    method _get_href : string
  end

  class type area =
  object
    inherit element
  end

  class type uRI =
  object
    constraint uRI = Common.uRI
    method _get_spec : string
    method _set_spec : string -> unit
    method resolve : string -> string
  end

  class type browser =
  object
    inherit element
    method loadURI : string -> uRI -> string -> unit
    method goBack : unit
    method _get_contentDocument : document
  end

  class type button =
  object
    inherit element
    method _get_disabled : bool
    method _set_disabled : bool -> unit
    method _get_label : string
    method _set_label : string -> unit
  end

  class type deck =
  object
    inherit element
    method _get_selectedIndex : int
    method _set_selectedIndex : int -> unit
  end

  class type dialog =
  object
    inherit element
  end

  class type form =
  object
    inherit element
    method submit : unit
  end

  class type input =
  object
    inherit element
  end

  class type input_text =
  object
    inherit input
    method _get_value : string
    method _set_value : string -> unit
  end

  class type input_image =
  object
    inherit input
    method click : unit
  end

  class type label =
  object
    method _get_value : string
    method _set_value : string -> unit
  end

  class type map =
  object
    inherit element
    method _get_areas : area array
  end

  class type menuItem =
  object
    inherit element
  end

  class type menuList =
  object
    inherit element
    method _get_selectedIndex : int
    method _set_selectedIndex : int -> unit
    method _get_value : string
    method _set_value : string -> unit
  end

  class type mouseEvent =
  object
    inherit event
    method _get_screenX : int
    method _get_screenY : int
    method _get_clientX : int
    method _get_clientY : int
    method _get_ctrlKey : bool
    method _get_shiftKey : bool
    method _get_altKey : bool
    method _get_metaKey : bool
    method _get_button : int
    method _get_relatedTarget : eventTarget
    method initMouseEvent :
      string -> bool -> bool -> abstractView -> int ->
      int -> int -> int -> int ->
      bool -> bool -> bool -> bool ->
      int -> eventTarget ->
      unit
  end

  class type option =
  object
    inherit element
    method _get_text : string
    method _get_value : string
  end

  class type radio =
  object
    inherit element
    method _get_selected : int
    method _set_selected : int -> unit
  end

  class type select =
  object
    inherit element
    method _get_options : option array
    method _get_selectedIndex : int
    method _set_selectedIndex : int -> unit
  end

  class type statusBarPanel =
  object
    inherit element
  end

  class type stringBundle =
  object
    method getString : string -> string
  end

  class type tab =
  object
    inherit element
    method _get_linkedBrowser : browser
  end

  class type tabBrowser =
  object
    inherit element
    method addTab : string -> tab
    method removeTab : tab -> unit
    method _set_selectedTab : #tab -> unit
  end

  class type textBox =
  object
    inherit element
    method _get_value : string
    method _set_value : string -> unit
  end

  class type window =
  object
    inherit element
    method alert : string -> unit
    method back : unit
    method close : unit
    method _get_location : string
    method _set_location : string -> unit
    method openDialog : string -> string -> string -> unit
    method getBrowser : tabBrowser
    method setTimeout : (unit -> unit) Ocamljs.jsfun -> float -> int
    method clearTimeout : int -> unit
    method setInterval : (unit -> unit) Ocamljs.jsfun -> float -> int
    method clearInterval : int -> unit
  end

  let document = Ocamljs.var "document"
  let window = Ocamljs.var "window"
end

module XPCOM =
struct
  type class_
  type 'a interface
  type result

  class type supports =
  object
    method _QueryInterface : 'a interface -> 'a
  end

  class type supportsWeakReference =
  object
  end

  class type iDRef =
  object
    method equals : 'a interface -> bool
  end

  class type ['a] out =
  object
    method _get_value : 'a
    method _set_value : 'a -> unit
  end

  class type inputStream =
  object
  end

  class type bufferedInputStream =
  object
    inherit inputStream
    method init : #inputStream -> int -> unit
  end

  class type uRI =
  object
    constraint uRI = Common.uRI
    method _get_spec : string
    method _set_spec : string -> unit
    method resolve : string -> string
  end

  class type channel =
  object
    inherit supports
    method _get_URI : uRI
  end

  class type consoleService =
  object
    method logStringMessage : string -> unit
  end

  class type cookie =
  object
    method _get_name : string
    method _get_value : string
    method _get_host : string
    method _get_path : string
  end

  class type ['a] simpleEnumerator =
  object
    method hasMoreElements : bool
    method getNext : 'a
  end

  class type cookieManager =
  object
    method remove : string -> string -> string -> bool -> unit
    method _get_enumerator : supports simpleEnumerator
  end

  class type file =
  object
    method remove : bool -> unit
    method append : string -> unit
  end

  class type fileInputStream =
  object
    inherit inputStream
    method init : #file -> int -> int -> int -> unit
  end

  class type outputStream =
  object
    method write : string -> int -> unit
    method close : unit
  end

  class type fileOutputStream =
  object
    inherit outputStream
    method init : #file -> int -> int -> int -> unit
  end

  class type httpChannel =
  object
    method setRequestHeader : string -> string -> bool -> unit
  end

  class type request =
  object
    inherit supports
    method _get_name : string
    method isPending : bool
    method _get_status : int
    method cancel : int -> unit
    method suspend : unit
    method resume : unit
  end

  class type requestObserver =
  object
    inherit supports
    method onStartRequest : #request -> #supports -> unit
    method onStopRequest : #request -> #supports -> int -> unit
  end

  class type streamListener =
  object
    inherit requestObserver
    method onDataAvailable : #request -> #supports -> #inputStream -> float -> float -> unit
  end

  class type inputStreamPump =
  object
    inherit request
    method init : #inputStream -> float -> float -> float -> float -> bool -> unit
    method asyncRead : #streamListener -> #supports -> unit
  end

  class type localFile =
  object
    inherit file
    method setRelativeDescriptor : localFile -> string -> unit
  end

  class type mIMEInputStream =
  object
    inherit inputStream
    method _set_addContentLength : bool -> unit
    method addHeader : string -> string -> unit
    method setData : #inputStream -> unit
  end

  class type multiplexInputStream =
  object
    inherit inputStream
    method appendStream : #inputStream -> unit
  end

  class type observer =
  object
    method observe : #supports -> string -> string -> unit
  end

  class type observerService =
  object
    method addObserver : observer -> string -> bool -> unit
    method removeObserver : observer -> string -> unit
  end

  class type passwordManager =
  object
    method addUser : string -> string -> string -> unit
    method removeUser : string -> string -> unit
    method addReject : string -> unit
    method removeReject : string -> unit
  end

  class type passwordManagerInternal =
  object
    method findPasswordEntry : string -> string -> string -> string out -> string out -> string out -> unit
    method addUserFull : string -> string -> string -> string -> string -> unit
  end

  class type prefBranch =
  object
    method _get_PREF_BOOL : int
    method _get_PREF_INT : int
    method _get_PREF_STRING : int
    method getPrefType : string -> int
    method getBoolPref : string -> bool
    method getCharPref : string -> string
    method getIntPref : string -> int
    method setBoolpref : string -> bool -> unit
    method setCharPref : string -> string -> unit
    method setIntPref : string -> int -> unit
  end

  class type properties =
  object
    method get : string -> 'a interface -> 'a
  end

  class type scriptableInputStream =
  object
    inherit inputStream
    method init : #inputStream -> unit
    method close : unit
    method available : float
    method read : float -> string
  end

  class type transport =
  object
    method close : int -> unit
    method openInputStream : int -> int -> int -> inputStream
    method openOutputStream : int -> int -> int -> outputStream
  end

  class type serverSocket =
  object
    method asyncListen : serverSocketListener -> unit
    method close : unit
    method init : int -> bool -> int -> unit
  end

  and serverSocketListener =
  object
    method onSocketAccepted : serverSocket -> #transport -> unit
    method onStopListening : serverSocket -> int -> unit
  end

  class type stringInputStream =
  object
    inherit inputStream
    method setData : string -> int -> unit
  end

  class type uRIContentListener =
  object
    inherit supports
    method onStartURIOpen : #uRI -> bool
    method doContent : string -> bool -> #request -> streamListener out -> bool
    method isPreferred : string -> string out -> bool
    method canHandleContent : string -> bool -> string out
    (* loadCookie, parentContentListener *)
  end

  class type uRILoader =
  object
    inherit supports
    method registerContentListener : #uRIContentListener -> unit
    method unRegisterContentListener : #uRIContentListener -> unit
  end

  class type windowMediator =
  object
    method getEnumerator : string -> DOM.window simpleEnumerator
    method getMostRecentWindow : string -> DOM.window
  end

  class type xMLHttpRequest =
  object
    method _set_onreadystatechange : (unit -> unit) Ocamljs.jsfun -> unit
    method _set_onload : (unit -> unit) Ocamljs.jsfun -> unit
    method _open : string -> string -> bool -> unit
    method setRequestHeader : string -> string -> unit
    method getResponseHeader : string -> string
    method overrideMimeType : string -> unit
    method send : #inputStream -> unit
    method _get_readyState : int
    method _get_responseText : string
    method _get_channel : channel
    method abort : unit
    method _get_status : int
  end

  external createInstance : class_ -> 'a interface -> 'a = "#createInstance"
  external getService : class_ -> 'a interface -> 'a = "#getService"

  let cc c = Ocamljs.hashref (Ocamljs.fieldref (Ocamljs.var "Components") "classes") c
  let ci i = Ocamljs.hashref (Ocamljs.fieldref (Ocamljs.var "Components") "interfaces") i
  let cr r = Ocamljs.hashref (Ocamljs.fieldref (Ocamljs.var "Components") "results") r

  let bufferedInputStream = ci "nsIBufferedInputStream"
  let consoleService = ci "nsIConsoleService"
  let cookie = ci "nsICookie"
  let cookieManager = ci "nsICookieManager"
  let file = ci "nsIFile"
  let fileInputStream = ci "nsIFileInputStream"
  let fileOutputStream = ci "nsIFileOutputStream"
  let httpChannel = ci "nsIHttpChannel"
  let inputStreamPump = ci "nsIInputStreamPump"
  let localFile = ci "nsILocalFile"
  let mIMEInputStream = ci "nsIMIMEInputStream"
  let multiplexInputStream = ci "nsIMultiplexInputStream"
  let observer = ci "nsIObserver"
  let observerService = ci "nsIObserverService"
  let passwordManager = ci "nsIPasswordManager"
  let passwordManagerInternal = ci "nsIPasswordManagerInternal"
  let prefBranch = ci "nsIPrefBranch"
  let properties = ci "nsIProperties"
  let requestObserver = ci "nsIRequestObserver"
  let scriptableInputStream = ci "nsIScriptableInputStream"
  let serverSocket = ci "nsIServerSocket"
  let streamListener = ci "nsIStreamListener"
  let stringInputStream = ci "nsIStringInputStream"
  let supports = ci "nsISupports"
  let supportsWeakReference = ci "nsISupportsWeakReference"
  let uRI = ci "nsIURI"
  let uRIContentListener = ci "nsIURIContentListener"
  let uRILoader = ci "nsIURILoader"
  let windowMediator = ci "nsIWindowMediator"

  let appshell_window_mediator = cc "@mozilla.org/appshell/window-mediator;1"
  let consoleservice = cc "@mozilla.org/consoleservice;1"
  let cookiemanager = cc "@mozilla.org/cookiemanager;1"
  let file_directory_service = cc "@mozilla.org/file/directory_service;1"
  let file_local = cc "@mozilla.org/file/local;1"
  let io_multiplex_input_stream = cc "@mozilla.org/io/multiplex-input-stream;1"
  let io_string_input_stream = cc "@mozilla.org/io/string-input-stream;1"
  let network_buffered_input_stream = cc "@mozilla.org/network/buffered-input-stream;1"
  let network_file_input_stream = cc "@mozilla.org/network/file-input-stream;1"
  let network_file_output_stream = cc "@mozilla.org/network/file-output-stream;1"
  let network_input_stream_pump = cc "@mozilla.org/network/input-stream-pump;1"
  let network_mime_input_stream = cc "@mozilla.org/network/mime-input-stream;1"
  let network_server_socket = cc "@mozilla.org/network/server-socket;1"
  let network_simple_uri = cc "@mozilla.org/network/simple-uri;1"
  let observer_service = cc "@mozilla.org/observer-service;1"
  let passwordmanager = cc "@mozilla.org/passwordmanager;1"
  let preferences_service = cc "@mozilla.org/preferences-service;1"
  let scriptableinputstream = cc "@mozilla.org/scriptableinputstream;1"
  let uriloader = cc "@mozilla.org/uriloader;1"

  let nOINTERFACE = cr "NS_NOINTERFACE"

  let getService_appshell_window_mediator () = getService appshell_window_mediator windowMediator
  let getService_consoleservice () = getService consoleservice consoleService
  let getService_cookiemanager () = getService cookiemanager cookieManager
  let getService_file_directory_service () = getService file_directory_service properties
  let getService_observer_service () = getService observer_service observerService
  let getService_passwordmanager_passwordManager () = getService passwordmanager passwordManager
  let getService_passwordmanager_passwordManagerInternal () = getService passwordmanager passwordManagerInternal
  let getService_preferences_service () = getService preferences_service prefBranch
  let getService_uriloader () = getService uriloader uRILoader

  let createInstance_file_local () = createInstance file_local localFile
  let createInstance_network_buffered_input_stream () = createInstance network_buffered_input_stream bufferedInputStream
  let createInstance_network_file_input_stream () = createInstance network_file_input_stream fileInputStream
  let createInstance_network_file_output_stream () = createInstance network_file_output_stream fileOutputStream
  let createInstance_network_mime_input_stream () = createInstance network_mime_input_stream mIMEInputStream
  let createInstance_io_multiplex_input_stream () = createInstance io_multiplex_input_stream multiplexInputStream
  let createInstance_io_string_input_stream () = createInstance io_string_input_stream stringInputStream
  let createInstance_scriptableinputstream () = createInstance scriptableinputstream scriptableInputStream
  let createInstance_network_input_stream_pump () = createInstance network_input_stream_pump inputStreamPump
  let createInstance_network_server_socket () = createInstance network_server_socket serverSocket
  let createInstance_network_simple_uri () = createInstance network_simple_uri uRI

  let make_out v = Ocamljs.obj [ "value", v ]
  external newXMLHttpRequest : unit -> xMLHttpRequest = "$new" "XMLHttpRequest"
end
