TINY = {};

TINY.box = function () {
    var j, m, b, g, v, p = 0;
    return {
        show: function (o) {
            v = {
                opacity: 70,
                close: 1,
                animate: 0,
                fixed: 1,
                mask: 1,
                maskid: '',
                boxid: '',
                topsplit: 2,
                url: 0,
                post: 0,
                height: 0,
                width: 0,
                html: 0,
                iframe: 0
            };
            for (s in o) {
                v[s] = o[s];
            }
            if (!p) {
                j = document.createElement('div');
                j.className = 'tbox';
                p = document.createElement('div');
                p.className = 'tinner';
                b = document.createElement('div');
                b.className = 'tcontent', b.id = 'tcontent';
                m = document.createElement('div');
                m.className = 'tmask';
                g = document.createElement('div');
                g.className = 'tclose';
                g.v = 0;
                g.innerHTML = '<a href="javascript:">fechar</a>';
                h = document.createElement('div');
                h.className = 'thistory';
                h.innerHTML = '<a href="javascript:">voltar</a>';
                document.body.appendChild(m);
                document.body.appendChild(j);
                j.appendChild(p);
                p.appendChild(b);
                p.appendChild(h);
                m.onclick = g.onclick = TINY.box.hide;
                window.onresize = TINY.box.resize;
            } else {
                j.style.display = 'none';
                clearTimeout(p.ah);
                if (g.v) {
                    p.removeChild(g);
                    g.v = 0;
                }
            }
            p.id = v.boxid;
            m.id = v.maskid;
            j.style.position = v.fixed ? 'fixed' : 'absolute';
            if (v.html && !v.animate) {
                p.style.backgroundImage = 'none';
                b.innerHTML = v.html;
                b.style.display = '';
                p.style.width = v.width ? v.width + 'px' : 'auto';
                //p.style.height=v.height?v.height+'px':'auto'
            } else {
                b.style.display = 'none';
                if (!v.animate && v.width && v.height) {
                    p.style.width = v.width + 'px';
                    p.style.height = v.height + 'px';
                } else {
                    p.style.width = p.style.height = '100px';
                }
            }
            if (v.mask) {
                this.mask();
                this.alpha(m, 1, v.opacity);
            } else {
                this.alpha(j, 1, 100);
            }
            ;
            if (v.autohide) {
                p.ah = setTimeout(TINY.box.hide, 1000 * v.autohide);
            } else {
                document.onkeyup = TINY.box.esc;
            }
        },
        fill: function (c, u, k, a, w, h) {
            if (u) {
                if (v.image) {
                    var i = new Image();
                    i.onload = function () {
                        w = w || i.width;
                        h = h || i.height;
                        TINY.box.psh(i, a, w, h);
                    };
                    i.src = v.image;
                } else if (v.iframe) {
                    this.psh('<iframe src="' + v.iframe + '" width="' + v.width + '" frameborder="0" height="' + v.height + '"></iframe>', a, w, h);
                } else {
                    var x = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject('Microsoft.XMLHTTP');
                    x.onreadystatechange = function () {
                        if (x.readyState == 4 && x.status == 200) {
                            p.style.backgroundImage = '';
                            TINY.box.psh(x.responseText, a, w, h);
                        }
                    };
                    if (k) {
                        x.open('POST', c, true);
                        x.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                        x.send(k);
                    } else {
                        x.open('GET', c, true);
                        x.send(null);
                    }
                }
            } else {
                this.psh(c, a, w, h);
            }
        },
        psh: function (c, a, w, h) {
            if (typeof c == 'object') {
                b.appendChild(c);
            } else {
                b.innerHTML = c;
            }
            var x = p.style.width, y = p.style.height;
            if (!w || !h) {
                p.style.width = w ? w + 'px' : '';
                p.style.height = h ? h + 'px' : '';
                b.style.display = '';
                if (!h) {
                    h = parseInt(b.offsetHeight);
                }
                if (!w) {
                    w = parseInt(b.offsetWidth);
                }
                b.style.display = 'none';
            }
            p.style.width = x;
            p.style.height = y;
            this.size(w, h, a);
        },
        esc: function (e) {
            e = e || window.event;
            if (e.keyCode == 27) {
                TINY.box.close_without_reload();
            }
        },
        close_without_reload: function () {
            TINY.box.alpha(j, -1, 0, 3);
            document.onkeypress = null;
            hideImg();
            jQuery('#history-cache').html('');
            jQuery('.thistory').hide();
        },
        hide: function (hash) {
            //fechado pelo mouse
            if (hash && hash.target) {
                TINY.box.close_without_reload();
            }
            else {
                TINY.box.alpha(j, -1, 0, 3);
                document.onkeypress = null;
                if (v.closejs) {
                    v.closejs(hash);
                }
            }
        },
        resize: function () {
            TINY.box.pos();
            TINY.box.mask();
        },
        mask: function () {
            m.style.height = this.total(1) + 'px';
            m.style.width = this.total(0) + 'px';
        },
        pos: function () {
            var t;
            if (typeof v.top != 'undefined') {
                t = v.top;
            } else {
                t = (this.height() / v.topsplit) - (j.offsetHeight / 2);
                t = t < 20 ? 20 : t;
            }
            if (!v.fixed && !v.top) {
                t += this.top();
            }
            j.style.top = t + 'px';
            j.style.left = typeof v.left != 'undefined' ? v.left + 'px' : (this.width() / 2) - (j.offsetWidth / 2) + 'px';
            p.style.maxHeight = this.height() - 50 + "px";
        },
        alpha: function (e, d, a) {
            clearInterval(e.ai);
            if (d) {
                e.style.opacity = 0;
                e.style.filter = 'alpha(opacity=0)';
                e.style.display = 'block';
            }
            e.ai = setInterval(function () {
                TINY.box.ta(e, a, d);
            }, 20);
            e.ei = setInterval(function () {
                TINY.box.pos();
            }, 500);
        },
        ta: function (e, a, d) {
            var o = Math.round(e.style.opacity * 100);
            if (o == a) {
                clearInterval(e.ai);
                if (d == -1) {
                    e.style.display = 'none';
                    e == j ? TINY.box.alpha(m, -1, 0, 2) : b.innerHTML = p.style.backgroundImage = '';
                } else {
                    if (e == m) {
                        this.alpha(j, 1, 100);
                    } else {
                        j.style.filter = '';
                        TINY.box.fill(v.html || v.url, v.url || v.iframe || v.image, v.post, v.animate, v.width, v.height);
                    }
                }
            } else {
                var n = a - Math.floor(Math.abs(a - o) * .5) * d;
                e.style.opacity = n / 100;
                e.style.filter = 'alpha(opacity=' + n + ')';
            }
        },
        size: function (w, h, a) {
            if (a) {
                clearInterval(p.si);
                var wd = parseInt(p.style.width) > w ? -1 : 1, hd = parseInt(p.style.height) > h ? -1 : 1;
                p.si = setInterval(function () {
                    TINY.box.ts(w, wd, h, hd);
                }, 20);
            } else {
                p.style.backgroundImage = 'none';
                if (v.close) {
                    p.appendChild(g);
                    g.v = 1;
                }
                p.style.width = w + 'px';
                p.style.height = h + 'px';
                b.style.display = '';
                this.pos();
                if (v.openjs) {
                    v.openjs();
                }
            }
        },
        ts: function (w, wd, h, hd) {
            var cw = parseInt(p.style.width), ch = parseInt(p.style.height);
            if (cw == w && ch == h) {
                clearInterval(p.si);
                p.style.backgroundImage = 'none';
                b.style.display = 'block';
                if (v.close) {
                    p.appendChild(g);
                    g.v = 1;
                }
                if (v.openjs) {
                    v.openjs();
                }
            } else {
                if (cw != w) {
                    p.style.width = (w - Math.floor(Math.abs(w - cw) * .6) * wd) + 'px';
                }
                if (ch != h) {
                    p.style.height = (h - Math.floor(Math.abs(h - ch) * .6) * hd) + 'px';
                }
                this.pos();
            }
        },
        top: function () {
            return document.documentElement.scrollTop || document.body.scrollTop;
        },
        width: function () {
            return self.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
        },
        height: function () {
            return self.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
        },
        total: function (d) {
            var b = document.body, e = document.documentElement;
            return d ? Math.max(Math.max(b.scrollHeight, e.scrollHeight), Math.max(b.clientHeight, e.clientHeight)) :
                Math.max(Math.max(b.scrollWidth, e.scrollWidth), Math.max(b.clientWidth, e.clientWidth));
        }
    };
}();

function request(url) {
    serial = '_serial=' + Math.random();
    if (url.indexOf('?') >= 0)
        url += '&' + serial;
    else
        url += '?' + serial;
    jQuery.ajax({
        type: 'GET',
        url: url,
        ContentType: "application/x-www-form-urlencoded;charset=UTF-8",
        success: function (data) {
            hideImg();
            evalScripts(data);
            html = getContent(data, 'content');
            jQuery('#content').html(html);
            //setUpLinks(); //Nao sei o que isso faz e está dando erro
        },
        error: showError
    });
}

function showError() {
    showImg();
    jQuery('body').css('cursor', 'default');
    TINY.box.show({
        html: '<h2>Página não encontrada</h2>\
        <p>O endereço selecionado é inválido ou a página que você procura não existe mais.</p>\
        <p>Você pode voltar para a <a href="">página atual</a> e tentar um outro endereço.</p>',
        width: 500,
        opacity: 50,
        closejs: function () {
            hideImg();
            window.location.reload();
        },
        topsplit: 2,
        mask: 0
    });
}

function showImg(wait) {
    $('body').addClass('stop-scrolling');
    if (jQuery('#loading-tinybox:visible').length == 0) {
        if (wait == undefined) {
            jQuery('#loading-tinybox-image').show();
            jQuery('#loading-tinybox-image-wait').hide();
        } else {
            jQuery('#loading-tinybox-image-wait').show();
            jQuery('#loading-tinybox-image').hide();
        }
        jQuery('#loading-tinybox').show();
    }
}

function hideImg() {
    $('body').removeClass('stop-scrolling');
    jQuery('#loading-tinybox').hide();
    jQuery('#loading-tinybox-image').hide();
}

var GLOBAL_URL = null;
function popup(url, width, height, qs, reloadOnClose) {
    if (reloadOnClose === undefined) {
        reloadOnClose = true;
    }
    if (reloadOnClose == "false") {
        reloadOnClose = false;
    }
    showImg();
    jQuery('body').css('cursor', 'wait');
    var reloadOnClose = reloadOnClose;
    GLOBAL_URL = url;
    if (qs == null) {
        type = 'GET';
        var dados = {};
    } else {
        type = 'POST';
        var dados = {
            qs: qs
        };
    }

    jQuery.ajax({
        type: type,
        url: url,
        data: dados,
        success: function (data) {
            var data = data;
            var scriptsAndLinks = getAndAddScriptsAndLinks(data);
            var html = getContent(data);
            jQuery('body').css('cursor', 'default');
            openjs = function () {
                setUpForms(scriptsAndLinks);
                evalScripts(html);
                //TODO: verificar se tem como pegar todos
                var inputs_aceitos = 'input[type="text"], input[type="checkbox"], input[type="radio"], input[type="password"], select, textarea';
                var inputs = jQuery('.tbox').find(inputs_aceitos);
                var inputs_html = jQuery(html).find('.tbox').find(inputs_aceitos);
                // Se existir input no popup e ele tiver id pega o elemento da página pelo id e dá foco nele
                if (inputs_html.length > 0) {
                    jQuery('#' + inputs_html[0].id).focus();
                } else if (inputs.length > 0) {
                    inputs[0].focus();
                }
                jQuery('.thistory').unbind().click(function (e) {
                    if (jQuery('[id^=history-url_]').length == 2) {
                        jQuery('.thistory').hide();
                    }
                    popup(history_pop(), 1000, null, null, reloadOnClose);
                });
            };

            closejs = function (hash) {
                hideImg();
                jQuery('#history-cache').html('');
                jQuery('.thistory').hide();
                var forms = document.getElementsByTagName('form');
                var tokens = url.split('source_input=');

                if (reloadOnClose) {
                    //Adicionado para poder recarregar os javascripts e css para não dar conflito
                    if (hash && typeof hash == 'string'){
                        url = window.location.href.split('#')[0]
                        .replace('?', '__='+Math.random()+'&') + '#' + hash;
                    }
                    else url = window.location.href;
                    window.location.href = url;
                    window.location.reload(true);
                } else if (qs == null) {
                    if (tokens.length > 1) {
                        reload(tokens[1], hash);
                    }
                }
            };
            var p = document.getElementById('feedback_message');
            if (p != null)
                p.parentNode.removeChild(p);
            if (jQuery('.tcontent:visible').length > 0) {
                jQuery('.tcontent').html(html).ready(function () {
                    replaceAddAnotherLinks();
                });
            } else {
                TINY.box.show({
                    html: html,
                    width: width,
                    height: height,
                    opacity: 50,
                    topsplit: 2,
                    openjs: openjs,
                    closejs: closejs,
                    mask: 0
                });
            }
        },
        error: showError
    });
}

function reload(id, hash) {
    if (id) {
        jQuery.ajax({
            type: 'GET',
            url: document.location.href + '#' + hash,
            success: function (data) {
                var html = getContent(data, id);
                document.getElementById(id).innerHTML = html;
                evalScripts(html);
                replaceAddAnotherLinks();
                var element = jQuery("#" + id);
                initAll(element);
                jQuery.getScript('/static/djtools/js/tabs.js');
            }
        });
    }
}

function setUpForms(scriptsAndLinks) {
    var scriptsAndLinks = scriptsAndLinks;
    reloadJS(scriptsAndLinks);
    replaceAddAnotherLinks();
    var forms = document.getElementById('tcontent').getElementsByTagName('form');
    for (var i = 0; i < forms.length; i++) {
        var form = forms[i];
        form.onsubmit = function () {
            var params = 'popup=1&' + jQuery(this).serialize();
            url = GLOBAL_URL;
            if (url.indexOf('?') == -1)
                url += '?popup=1';
            else
                url += '&popup=1';

            var formData = new FormData(this);
            formData.append("popup", "1");

            $.ajax({
                url: url,
                type: 'POST',
                data: formData,
                async: false,
                success: function (data) {
                    var html = getContent(data);
                    var tbox = document.getElementById('tcontent');
                    tbox.innerHTML = html;
                    setUpForms(scriptsAndLinks);
                    evalScripts(html);
                },
                cache: false,
                contentType: false,
                processData: false
            });

            return false;
        };
    }
}

/*
 * Retorna uma lista com os scripts do parametro 'html' que não existem na página atual e adiciona nela.
 */

function getAndAddScriptsAndLinks(html) {
    var scriptsAndLinks = [];
    for (var i = 0; i < jQuery(html).length; i++) {
        element = jQuery(html)[i];
        if (element.tagName == "LINK" || element.tagName == "SCRIPT") {
            if (document.head.innerHTML.indexOf(element.outerHTML) < 0) {
                //Esse if é necessário para evitar adicionar o jquery antigo no head quando abrir um popup
                if (element.src == undefined || element.src.toLowerCase().indexOf('/static/admin/js/') <= 0) {
                    jQuery('head').append(element);
                }
                scriptsAndLinks.push(element);
            }
            if (element.tagName == "SCRIPT" && (element.src.toLowerCase().indexOf('/static/djtools/') < 0) && (element.src.toLowerCase().indexOf('/static/comum/') < 0)){
                scriptsAndLinks.push(element);
            }
        }
    }
    return scriptsAndLinks;
}


function reloadJS(scriptsAndLinks) {
    for (var i = 0; i < scriptsAndLinks.length; i++) {
        element = scriptsAndLinks[i];
        if (element.tagName == "SCRIPT") {
            if(element.src) {
                //jQuery.getScript(element.src);
            }
        }
    }
}

function evalScripts(html) {
    var codes = html.split(/<script.*?>/gi);
    for (var i = 1; i < codes.length; i++) {
        var b = codes[i].indexOf('</script>');
        var code = codes[i].substring(0, b);
        try {
            this.eval(code);
        } catch (Exception) {
            //alert(Exception);
        }
    }
    jQuery.getScript('/static/comum/js/main.js');
    jQuery.getScript('/static/djtools/jquery/widgets-core.js');
}

function escapeRegExp(str) {
    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

function replaceAll(str, find, replace) {
    return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}

function getContent(data, id) {
    if (!id)
        id = 'content';
    var div = document.createElement('html');
    data = replaceAll(data, '&lt;', '?lt;');
    data = replaceAll(data, '&gt;', '?gt;');
    div.innerHTML = data;
    var content = findNodeWithId(div, id);
    if (content == null)
        return data;
    else
        data = content.innerHTML;
        data = replaceAll(data, '?lt;', '&lt;');
        data = replaceAll(data, '?gt;', '&gt;');
        return data;
}

function findNodeWithId(node, id) {
    if (node == null)
        return null;
    for (var i = 0; i < node.childNodes.length; i++) {
        if (node.id == id) {
            return node;
        } else {
            var el = findNodeWithId(node.childNodes[i], id);
            if (el != null)
                return el;
        }
    }
    return null;
}

function getActiveXObject() {
    try {
        return new XMLHttpRequest();
    } catch (e1) {
        try {
            return new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e2) {
            try {
                return new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e3) {
                return null;
            }
        }
    }
}

function replaceAddAnotherLinks() {
    var links = jQuery('.add-another');
    for (var i = 0; i < links.length; i++) {
        var link = links[i];
        var source_input = '';
        for (var j = 0; j < link.parentNode.childNodes.length; j++) {
            input = link.parentNode.childNodes[j];
            if (input.tagName == 'SELECT') {
                source_input = input.id;
            }
        }
        if (link.href.indexOf('&_popup=1&source_input=') < 0) {
            var first_char = '?';
            if (link.href.indexOf('?') > 0) {
                first_char = '&';
            }
            link.href = link.href + first_char + '_popup=1&source_input=' + source_input;
        }
        link.onclick = function (e) {
            var width = jQuery(this).attr('data-width');
            if (width == null)
                width = 1000;
            var height = jQuery(this).attr('data-height');
            if (height == null)
                height = null;
            var reloadOnClose = false;
            /*if (jQuery('.tcontent:visible').length > 0) {
             jQuery('.thistory').show();
             }
             history_push(this, reloadOnClose);
             */
            showImg();
            e.preventDefault();
            popup(this.href, width, height, null, reloadOnClose);
            return false;
        };
    }
    links = jQuery('.popup');
    for (var i = 0; i < links.length; i++) {
        var link = links[i];
        link.onclick = function (e) {
            var first_char = '?';
            if (this.href.indexOf('?') > 0) {
                first_char = '&';
            }
            var width = jQuery(this).attr('data-width');
            if (width == null)
                width = 1000;
            var height = jQuery(this).attr('data-height');
            if (height == null)
                height = null;
            var reloadOnClose = jQuery(this).attr('data-reload-on-close');
            if (jQuery('.tcontent:visible').length > 0) {
                jQuery('.thistory').show();
                reloadOnClose = jQuery('[id^=history-url_]').last().attr('data-reload-on-close');
            }
            history_push(this, reloadOnClose);
            showImg();
            e.preventDefault();
            this.href = this.href + first_char + '_popup=1';
            popup(this.href, width, height, null, reloadOnClose);
            replaceAddAnotherLinks();
            return false;
        };
    }
    links = jQuery('.wait');
    for (var i = 0; i < links.length; i++) {
        var link = links[i];
        link.onclick = function () {
            showImg(true);
            return true;
        };
    }
    links = jQuery('.ajax').click(function () {
        showImg();
        request(this.href);
        return false;
    });
    /* Barra de progresso */
    jQuery('.tcontent:visible').find(".progress p").each(function() {
        var texto = jQuery(this).text();
        var porcentagem = texto.indexOf("%");
        if (porcentagem==-1) {
            var split = texto.split('/');
            texto = split[0]*100/split[1] + "%";
        }
        jQuery(this).css("width", texto);
        jQuery(this).parent().attr("title", texto);
    });
}

function history_push(url, reload) {
    if (reload == undefined) {
        reload = true;
    }
    if (url != undefined) {
        if (url != jQuery('[id^=history-url_]').last().attr('href')) {
            jQuery('<a href="' + url + '" id="history-url_' + (jQuery('[id^=history-url_]').length + 1) +
            '" data-reload-on-close="' + reload + '"></a>').appendTo('#history-cache');
        }
    }
}

function history_pop() {
    if (jQuery('[id^=history-url_]').length > 1) {
        jQuery('[id^=history-url_]').last().remove();
        return jQuery('[id^=history-url_]').last().attr('href');
    }
    if (jQuery('[id^=history-url_]').length == 1) {
        jQuery('.thistory').hide();
        return '';
    }
}

function setWaitBackground() {
    var img = document.createElement('div');
    var body = document.body, html = document.documentElement;
    var height = Math.max(body.scrollHeight, body.offsetHeight,
        html.clientHeight, html.scrollHeight, html.offsetHeight);
    img.innerHTML = '<div id="loading-tinybox"></div>\
    <div id="loading-tinybox-image"></div>\
    <div id="loading-tinybox-image-wait"></div>\
    <div id="history-cache"></div>';
    document.body.appendChild(img);
    tinybox = document.getElementById('loading-tinybox');
    tinybox.style.height = $( document ).height()+1000 + 'px';
    jQuery('#loading-tinybox-image').height( $( window ).height());
    jQuery('#loading-tinybox-image-wait').height( $( document ).height());
}

/*
* Função criada para remover os links padrões do django admin
* Eles estavam com "conflito" com o tinybox
*/
function removerLinksAdminAdicaoEdicao() {
    jQuery('.add-related').remove();
    jQuery('.change-related').remove();
}

jQuery(document).ready(function () {
    replaceAddAnotherLinks();
    setWaitBackground();
    removerLinksAdminAdicaoEdicao();
});
