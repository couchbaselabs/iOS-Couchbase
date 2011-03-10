// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations under
// the License.

var ddoc = null;
var sandbox = null;
var compiled = {};
var started = false;
var finished = false;
var start_resp = {};
var row = null;
var chunks = [];

//
// Erlang Functions
//

var init = function(ctx_ddoc) {
  try {
    ddoc = ctx_ddoc;
    init_sandbox();
    return true;
  } catch(e) {
    return handleError(e);
  }
};
  
var show_doc = function(fname, doc, req) {
  try {
    resetState();
    
    var func = get_func(["shows", fname])
    var resp = func.apply(ddoc, [doc, req]) || {};

    if(chunks.length && chunks.length > 0) {
      resp = wrapResp(resp);
      resp.headers = resp.headers || {};
      for(var header in start_resp) {
        resp.headers[header] = start_resp[header];
      }
      resp.body = chunks.join("") + (resp.body || "");
    }
    
    if(Mime.providesUsed) {
      resp = Mime.runProvides(req);
      resp = setContentType(wrapResp(resp), Mime.responseContentType);
    }

    if (typeOf(resp) == 'object' || typeOf(resp) == 'string') {
      return ["resp", wrapResp(resp)];
    } else {
      throw(["error", "render_error", "show function returned invalid value."]);
    }
  } catch(e) {
    log("ERROR: " + JSON.stringify(e));
    if (doc === null && req.path) {
      return handleError(["error", "not_found", "document not found"]);
    } else {
      return handleError(e);
    }
  }
};

var list_view = function(fname, head, req) {
  try {
    resetState();
    var func = get_func(["lists", fname]);
    var tail = func.apply(ddoc, [head, req]);
    if(Mime.providesUsed) tail = Mime.runProvides(req);
    if(!started) getRow();
    if(typeof tail != "undefined") chunks.push(tail);
    return chunks;
  } catch(e) {
    return handleError(e);
  }
};

var update_doc = function(fname, doc, req) {
  try {
    if(req.method == "GET") {
      throw(["error","method_not_allowed","Update functions do not allow GET"]);
    }
    var func = get_func(["updates", fname]);
    var result = func.apply(ddoc, [doc, req]);
    var doc = result[0];
    var resp = result[1];
    if(typeOf(resp) === "object" || typeOf(resp) === "string") {
      return [doc, wrapResp(resp)];
    } else {
      throw(["error", "render_error", "update function returned bad value."]);
    }
  } catch(e) {
    return handleError(e);
  }
};

var validate_update = function(editdoc, diskdoc, ctx, secobj) {
  try {
    var func = get_func(["validate_doc_update"]);
    func.apply(ddoc, [editdoc, diskdoc, ctx, secobj]);
    return 1;
  } catch(e) {
    return e;
  }
};

var filter_docs = function(fname, docs, req) {
  try {
    var func = get_func(["filters", fname]);
    var results = [];
    for(var i = 0; i < docs.length; i++) {
      results.push((func.apply(ddoc, [docs[i], req]) && true) || false);
    }
    return results;    
  } catch(e) {
    return handleError(e);
  }
};

//
// Sandbox Functions
//

var init_sandbox = function() {
  try {
    sandbox = erlang.evalcx("");
    sandbox.log = log;
    sandbox.JSON = JSON;
    sandbox.toJSON = JSON.stringify;
    sandbox.provides = Mime.provides;
    sandbox.registerType = Mime.registerType;
    sandbox.start = start;
    sandbox.send = send;
    sandbox.getRow = getRow;
    sandbox.require = require;
  } catch(e) {
    throw(e);
  }
};

var log = function(msg) {
  erlang.send(["log", msg]);
}

var require = function(name, parent) {
  parent = parent || {};
  var resolved = resolve(name.split("/"), parent.actual, ddoc, parent.id);
  var src = "function(module, exports, require) {" + resolved[0] + "}";
  var func = erlang.evalcx(src, sandbox);
  var module = {"id": resolved[2], "actual": resolved[1], "exports": []};

  try { 
    var reqfunc = function(name) {return require(name, module);};
    func.apply(null, [module, module.exports, reqfunc]);
  } catch(e) {
    var msg = "require('" + name + "') raised error " + e.toSource();
    throw(["error", "compilation_error", msg]);
  }

  return module.exports;
};  

var start = function(resp) {
  start_resp = resp || {};
};

var send = function(chunk) {
  chunks.push(chunk.toString());
};

var getRow = function() {
  if(finished) return null;

  if(!started) {
    started = true;
    sendStart();
  } else {
    sendChunks();
  }

  if(row[0] === "list_end") {
    finished = true;
    return null;
  };

  if(row[0] != "list_row") {
    throw(["fatal", "list_error", "not a row '" + row[0] + "'"]);
  }

  return row[1];
};

//
// Internal Functions
//

var typeOf = function(value) {
  var t = typeof value;
  if(t === "object") {
    if(value && value instanceof Array) {
        return "array";
    } else if(!value) {
      return "null";
    }
  } 
  return t;
};

var resetState = function() {
  started = false;
  finished = false;
  start_resp = {};
  row = null;
  chunks = [];
  Mime.resetProvides();
};

var handleError = function(e) {
  var type = e[0];
  if(type == "fatal") {
    e[0] = "error";
    return e;
  } else if(type === "error") {
    return e;
  } else if(e.error && e.reason) {
    return ["error", e.error, e.reason];
  } else {
    return ["error", "unnamed_error", e.toSource()];
  }
};

var wrapResp = function(resp) {
  var type = typeOf(resp);
  if((type === "string") || (type === "xml")) {
    return {"body": resp};
  } else {
    return resp;
  }
};

var setContentType = function(resp, ctype) {
  resp["headers"] = resp["headers"] || {};
  if(ctype) {
    ctype = resp["headers"]["Content-Type"] || ctype;
    resp["headers"]["Content-Type"] = ctype;
  }
  return resp;
};

var sendStart = function() {
  start_resp = setContentType(start_resp || {}, Mime.responseContentType);
  row = erlang.send([chunks, start_resp]);
  chunks = [];
  resp = {};
};

var sendChunks = function(label) {
  row = erlang.send(chunks);
  chunks = [];
};

var resolve = function(names, parent, current, path) {
  if(names.length == 0) {
    if(typeof current != "string") {
      throw(["error", "bad_require_path", "Require paths must be a string."]);
    }
    return [current, parent, path];
  }

  var n = names.shift();
  if(n == '..') {
    if(!(parent && parent.parent)) {
      var obj = JSON.stringify(current);
      throw(["error", "bad_require_path", "Object has no parent: " + obj]);
    }
    path = path.slice(0, path.lastIndexOf("/"));
    return resolve(names, parent.parent.parent, parent.parent, path);
  } else if(n == ".") {
    if(!parent) {
      var obj = JSON.stringify(current);
      throw(["error", "bad_require_path", "Object has no parent: " + obj]);
    }
    return resolve(names, parent.parent, parent, path);
  }

  if(!current[n]) {
    throw(["error", "bad_require_path", "No such property " + n + ": " + obj]);
  }
  
  var p = current;
  current = current[n];
  current.parent = p;
  path = path ? path + '/' + n : n;
  return resolve(names, p, current, path);
};

var get_func = function(path) {
  curr = ddoc;
  comp = compiled;
  for(var i = 0; i < path.length-1; i++) {
    if(!ddoc[path[i]]) {
      throw(["error", "not_found", "Missing function: " + path.join(".")]);
    }
    curr = ddoc[path[i]];
    comp[path[i]] = comp[path[i]] || {};
    comp = comp[path[i]];
  }
  var i = path.length - 1;
  if(!curr[path[i]]) {
    throw(["error", "not_found", "Missing function: " + path.join(".")]);
  }
  comp[path[i]] = erlang.evalcx(curr[path[i]], sandbox);
  return comp[path[i]];
}

var Mime = (function() {
  var mimesByKey = {};
  var keysByMime = {};
  function registerType() {
    var mimes = [], key = arguments[0];
    for (var i=1; i < arguments.length; i++) {
      mimes.push(arguments[i]);
    };
    mimesByKey[key] = mimes;
    for (var i=0; i < mimes.length; i++) {
      keysByMime[mimes[i]] = key;
    };
  }

  registerType("all", "*/*");
  registerType("text", "text/plain; charset=utf-8", "txt");
  registerType("html", "text/html; charset=utf-8");
  registerType("xhtml", "application/xhtml+xml", "xhtml");
  registerType("xml", "application/xml", "text/xml", "application/x-xml");
  registerType("js", "text/javascript", "application/javascript", "application/x-javascript");
  registerType("css", "text/css");
  registerType("ics", "text/calendar");
  registerType("csv", "text/csv");
  registerType("rss", "application/rss+xml");
  registerType("atom", "application/atom+xml");
  registerType("yaml", "application/x-yaml", "text/yaml");
  registerType("multipart_form", "multipart/form-data");
  registerType("url_encoded_form", "application/x-www-form-urlencoded");
  registerType("json", "application/json", "text/x-json");
  
  var mimeFuns = [];
  function provides(type, fun) {
    Mime.providesUsed = true;
    mimeFuns.push([type, fun]);
  };

  function resetProvides() {
    // set globals
    Mime.providesUsed = false;
    mimeFuns = [];
    Mime.responseContentType = null;  
  };

  function runProvides(req) {
    var supportedMimes = [],
        bestFun,
        bestKey = null,
        accept = req.headers["Accept"];

    if (req.query && req.query.format) {
      bestKey = req.query.format;
      Mime.responseContentType = mimesByKey[bestKey][0];
    } else if (accept) {
      // log("using accept header: "+accept);
      mimeFuns.reverse().forEach(function(mimeFun) {
        var mimeKey = mimeFun[0];
        if (mimesByKey[mimeKey]) {
          supportedMimes = supportedMimes.concat(mimesByKey[mimeKey]);
        }
      });
      Mime.responseContentType = Mimeparse.bestMatch(supportedMimes, accept);
      bestKey = keysByMime[Mime.responseContentType];
    } else {
      // just do the first one
      bestKey = mimeFuns[0][0];
      Mime.responseContentType = mimesByKey[bestKey][0];
    }

    if (bestKey) {
      for (var i=0; i < mimeFuns.length; i++) {
        if (mimeFuns[i][0] == bestKey) {
          bestFun = mimeFuns[i][1];
          break;
        }
      };
    };

    if (bestFun) {
      return bestFun();
    } else {
      var supportedTypes = mimeFuns.map(function(mf) {
        return mimesByKey[mf[0]].join(', ') || mf[0]
      });
      var msg = "Content-Type " + (accept||bestKey) + 
                " not supported, try one of: "+supportedTypes.join(', ');
      throw(["error","not_acceptable", msg]);
    }
  };
  
  return {
    registerType : registerType,
    provides : provides,
    resetProvides : resetProvides,
    runProvides : runProvides
  }  
})();

// This module provides basic functions for handling mime-types. It can
// handle matching mime-types against a list of media-ranges. See section
// 14.1 of the HTTP specification [RFC 2616] for a complete explanation.
//
//   http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
//
// A port to JavaScript of Joe Gregorio's MIME-Type Parser:
//
//   http://code.google.com/p/mimeparse/
//
// Ported by J. Chris Anderson <jchris@apache.org>, targeting the Spidermonkey runtime.
//
// To run the tests, open mimeparse-js-test.html in a browser.
// Ported from version 0.1.2
// Comments are mostly excerpted from the original.

var Mimeparse = (function() {
  // private helpers
  function strip(string) {
    return string.replace(/^\s+/, '').replace(/\s+$/, '')
  };

  function parseRanges(ranges) {
    var parsedRanges = [], rangeParts = ranges.split(",");
    for (var i=0; i < rangeParts.length; i++) {
      parsedRanges.push(publicMethods.parseMediaRange(rangeParts[i]))
    };
    return parsedRanges;
  };

  var publicMethods = {
    // Carves up a mime-type and returns an Array of the
    //  [type, subtype, params] where "params" is a Hash of all
    //  the parameters for the media range.
    //
    // For example, the media range "application/xhtml;q=0.5" would
    //  get parsed into:
    //
    // ["application", "xhtml", { "q" : "0.5" }]
    parseMimeType : function(mimeType) {
      var fullType, typeParts, params = {}, parts = mimeType.split(';');
      for (var i=0; i < parts.length; i++) {
        var p = parts[i].split('=');
        if (p.length == 2) {
          params[strip(p[0])] = strip(p[1]);
        }
      };
      fullType = parts[0].replace(/^\s+/, '').replace(/\s+$/, '');
      if (fullType == '*') fullType = '*/*';
      typeParts = fullType.split('/');
      return [typeParts[0], typeParts[1], params];
    },

    // Carves up a media range and returns an Array of the
    //  [type, subtype, params] where "params" is a Object with
    //  all the parameters for the media range.
    //
    // For example, the media range "application/*;q=0.5" would
    //  get parsed into:
    //
    // ["application", "*", { "q" : "0.5" }]
    //
    // In addition this function also guarantees that there
    //  is a value for "q" in the params dictionary, filling it
    //  in with a proper default if necessary.
    parseMediaRange : function(range) {
      var q, parsedType = this.parseMimeType(range);
      if (!parsedType[2]['q']) {
        parsedType[2]['q'] = '1';
      } else {
        q = parseFloat(parsedType[2]['q']);
        if (isNaN(q)) {
          parsedType[2]['q'] = '1';
        } else if (q > 1 || q < 0) {
          parsedType[2]['q'] = '1';
        }
      }
      return parsedType;
    },

    // Find the best match for a given mime-type against
    // a list of media_ranges that have already been
    // parsed by parseMediaRange(). Returns an array of
    // the fitness value and the value of the 'q' quality
    // parameter of the best match, or (-1, 0) if no match
    // was found. Just as for qualityParsed(), 'parsed_ranges'
    // must be a list of parsed media ranges.
    fitnessAndQualityParsed : function(mimeType, parsedRanges) {
      var bestFitness = -1, bestFitQ = 0, target = this.parseMediaRange(mimeType);
      var targetType = target[0], targetSubtype = target[1], targetParams = target[2];

      for (var i=0; i < parsedRanges.length; i++) {
        var parsed = parsedRanges[i];
        var type = parsed[0], subtype = parsed[1], params = parsed[2];
        if ((type == targetType || type == "*" || targetType == "*") &&
          (subtype == targetSubtype || subtype == "*" || targetSubtype == "*")) {
          var matchCount = 0;
          for (param in targetParams) {
            if (param != 'q' && params[param] && params[param] == targetParams[param]) {
              matchCount += 1;
            }
          }

          var fitness = (type == targetType) ? 100 : 0;
          fitness += (subtype == targetSubtype) ? 10 : 0;
          fitness += matchCount;

          if (fitness > bestFitness) {
            bestFitness = fitness;
            bestFitQ = params["q"];
          }
        }
      };
      return [bestFitness, parseFloat(bestFitQ)];
    },

    // Find the best match for a given mime-type against
    // a list of media_ranges that have already been
    // parsed by parseMediaRange(). Returns the
    // 'q' quality parameter of the best match, 0 if no
    // match was found. This function bahaves the same as quality()
    // except that 'parsedRanges' must be a list of
    // parsed media ranges.
    qualityParsed : function(mimeType, parsedRanges) {
      return this.fitnessAndQualityParsed(mimeType, parsedRanges)[1];
    },

    // Returns the quality 'q' of a mime-type when compared
    // against the media-ranges in ranges. For example:
    //
    // >>> Mimeparse.quality('text/html','text/*;q=0.3, text/html;q=0.7, text/html;level=1, text/html;level=2;q=0.4, */*;q=0.5')
    // 0.7
    quality : function(mimeType, ranges) {
      return this.qualityParsed(mimeType, parseRanges(ranges));
    },

    // Takes a list of supported mime-types and finds the best
    // match for all the media-ranges listed in header. The value of
    // header must be a string that conforms to the format of the
    // HTTP Accept: header. The value of 'supported' is a list of
    // mime-types.
    //
    // >>> bestMatch(['application/xbel+xml', 'text/xml'], 'text/*;q=0.5,*/*; q=0.1')
    // 'text/xml'
    bestMatch : function(supported, header) {
      var parsedHeader = parseRanges(header);
      var weighted = [];
      for (var i=0; i < supported.length; i++) {
        weighted.push([publicMethods.fitnessAndQualityParsed(supported[i], parsedHeader), i, supported[i]])
      };
      weighted.sort();
      return weighted[weighted.length-1][0][1] ? weighted[weighted.length-1][2] : '';
    }
  }
  return publicMethods;
})();

