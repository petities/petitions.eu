/******************************************************
 * Copyright 2013 by Abaddon <abaddongit@gmail.com>
 * @author Abaddon <abaddongit@gmail.com>
 * @version 0.0.1
 * ***************************************************/
/*global window, $, jQuery, document */
(function ($) {
    "use strict";
    var w = window, d = document, $W = $(w), $D = $(d), $el = null, that = null,
        support,
        queryApi,
        config = {},
        sprites = {},
        blocks = null,
        ln = null,
    //размеры окна
        innerWidth = null,
        innerHeight = null;

    var Paralax = function (strategy) {
        this.strategy = strategy;
    };

    Paralax.prototype.start = function (el, defOption) {
        return this.strategy.init(el, defOption);
    };

    //Что-то типа абстрактного класса
    var GetParalax = function () { };

    //Описываем необходимые методы
    GetParalax.prototype.init = function (el, options) {
        that = el;
        var thisStyle = that.style;
        //Проверка на поддержку css-transform
        support = thisStyle.transition !== undefined || thisStyle.WebkitTransition !== undefined || thisStyle.MozTransition !== undefined || thisStyle.MsTransition !== undefined || thisStyle.OTransition !== undefined;
        queryApi = d.querySelector || false;
        config = options;
        innerWidth = w.innerWidth || d.documentElement.clientWidth,
        innerHeight = w.innerHeight || d.documentElement.clientHeight;

        if (!blocks) {
            blocks = d.querySelectorAll(config.layerClass);
            ln = blocks.length;
        }
        this.go();
    };

    GetParalax.prototype.go = function () { };
    /*
    * Получение координатов мыши
    */
    GetParalax.prototype.getXY = function (e) {
        //если IE 
        if (!e.pageX) {
            var html = d.documentElement;
            var body = d.body;

            e.pageX = e.clientX + (html && html.scrollLeft || body && body.scrollLeft || 0) - (html.clientLeft || 0);
            e.pageY = e.clientY + (html && html.scrollTop || body && body.scrollTop || 0) - (html.clientTop || 0);

        }
        return { 'mouseX': e.pageX, 'mouseY': 400 /* e.pageY   +++++++++++++++++++++++++++++++++++++++ aanpassing voor petities.nl +++++++++++++++++++++++++++++++++++++++ */ };
    };

    /*
    * Регистрирует событие
    * @param {String} type - имя события
    * @param {Object} el - объект дом на которое вашается событие
    * @param {Function} func - ф-я после отработки события
    */
    GetParalax.prototype.addEvent = function (type, el, func) {
        el.addEventListener(type, function (event) {
            var e = event || w.event;
            func.call(this, e);
        }, false);
    };
    /*
    * Создает элемент dom
    * @param {String} html - код эелемента
    * @return {Object}
    */
    GetParalax.prototype.createEl = function (html) {
        var div = d.createElement('div');
        div.innerHTML = html;
        var el = div.childNodes[0];
        div.removeChild(el);
        return el;
    };
    /*
    * Формирует css новое положение блока
    */
    GetParalax.prototype.getCssString = function (blockLeft, blockTop, mod) {
        var cssString = '';

        if (this instanceof BaseParalaxStr) {
            if (mod === undefined) {
                mod = 1;
            }

            if (!support) {
                cssString = 'left:' + blockLeft + 'px;' + 'top:' + blockTop + 'px;';
            } else {
                cssString = '-webkit-transition: -webkit-transform 1s easy;' +
                            '-moz-transition: -moz-transform 1s easy;' +
                            '-ms-transition: -ms-transform 1s easy;' +
                            '-o-transition: -o-transform 1s easy;' +
                            '-moz-transform: translate3d(' + blockLeft * mod + 'px, ' + blockTop * mod + 'px, 0px);' +
                            '-ms-transform: translate3d(' + blockLeft * mod + 'px, ' + blockTop * mod + 'px, 0px);' +
                            '-o-transform: translate3d(' + blockLeft * mod + 'px, ' + blockTop * mod + 'px, 0px);' +
                            '-webkit-transform: translate3d(' + blockLeft * mod + 'px, ' + blockTop * mod + 'px, 0px)';
            }
        }

        if (this instanceof VerticalParalaxStr) {
            if (!support) {
                cssString = 'top:' + blockTop + 'px;';
            } else {
                cssString = '-webkit-transition: top 0.7s;' +
                            '-moz-transition: top 0.7s;' +
                            '-ms-transition: top 0.7s;' +
                            '-o-transition: top 0.7s;' +
                            'transition: top 0.7s;' +
                            'top:' + blockTop + 'px;';
            }

            if (mod === "background") {
                cssString = '-webkit-transition: background-position 0.2s;' +
                            '-ms-transition: background-position 0.2s;' +
                            '-o-transition: background-position 0.2s;' +
                            '-moz-transition: background-position 0.2s;' +
                            'transition: background-position 0.2s;';
            }
        }

        return cssString;
    };

    //Базовая стратегия
    var BaseParalaxStr = function () {
        /*
        * Запускаем паралакс
        */
        this.go = function () {
            this.addEvent('mousemove', that, base.move);
        }

        this.move = function (e) {
            //находим координаты мыши
            var cords = base.getXY(e), blockLeft, blockTop;

            //Проходим по всем словам
            for (var i = 0; i < ln; i++) {
                var loc = blocks[i],
                    shift = loc.getAttribute('data-shift'); //коэффициет сдвига

                //Смещение по x
                blockLeft = shift * (0.5 * innerWidth - cords.mouseX);
                //Смешение по y
                blockTop = shift * (0.5 * innerHeight - cords.mouseY);

                if (config.differentSides) {
                    if (i % 2 === 0) {
                        loc.style.cssText = base.getCssString(blockLeft, blockTop);
                    } else {
                        loc.style.cssText = base.getCssString(blockLeft, blockTop, -1);
                    }
                } else {
                    loc.style.cssText = base.getCssString(blockLeft, blockTop);
                }
            }
        }
        var base = this;
    };

    BaseParalaxStr.prototype = Object.create(GetParalax.prototype);

    //Для горизонтального паралакса
    var VerticalParalaxStr = function () {
        this.go = function () {
            var spLen = null, totalHeight = 0;

            for (var i = 0; i < ln; i++) {
                var loc = blocks[i],
                        type = $(loc).data('type'),
                        img = loc.getAttribute('data-img');

                this.prepareSprites(loc);
                loc.style.cssText += vertical.getCssString(0, 0, "background") + 'background: url(' + img + ') 50% 0 fixed;';
                //построение навигации по блокам
                if (config.layerNav) {
                    this.createNavigation(loc, i);
                }
            }
            this.addEvent('scroll', d, vertical.scroll);
            //Вешаем событие на элемент навигации
            if (config.layerNav) {
                $D.on('click', '.wool-nav', vertical.changeSection);
            }
        }

        this.scroll = function (e) {
            for (var i = 0; i < ln; i++) {
                var loc = blocks[i],
                    offsetTop = loc.offsetTop,
                    spLen = 0;

                if (($W.scrollTop() + innerHeight) > (offsetTop) && ((offsetTop + $(loc).height()) > $W.scrollTop())) {
                    var yPos = -($W.scrollTop() / $(loc).data('shift'));

                    if ($(loc).data('offsety')) {
                        yPos += $(loc).data('offsety');
                    }

                    var coords = '50% ' + yPos + 'px';

                    $(loc).css({ backgroundPosition: coords });

                    if (loc.sprites) {
                        spLen = loc.sprites.length;
                    }

                    for (var j = 0; j < spLen; j++) {
                        var sprite = loc.sprites[j],
                            spTop = sprite.offset,
                            yPos = -($W.scrollTop() - offsetTop) / $(sprite).data('shift');

                        sprite.style.cssText += vertical.getCssString(0, yPos + spTop);
                    }

                    var locTop = offsetTop,
                        locBot = offsetTop + innerHeight,
                        passed = $W.scrollTop() + innerHeight * 25 / 100;

                    if (passed > locTop && passed < locBot) {
                        
                    }
                }
            }
        };
        /*
        * Запоменает начальные отступы плавующих элементов внутри секции
        * @param Object sector - секция
        */
        this.prepareSprites = function (sector) {
            var locSp = sector.querySelectorAll('[data-type="floating"]'),
                spLen = locSp.length;

            for (var j = 0; j < spLen; j++) {
                var spr = locSp[j],
                    offY = $(spr).data('offsety');

                spr.offset = spr.offsetTop;

                if (offY) {
                    spr.offset += offY;
                }
            }
            sector.sprites = locSp;
        };
        /*
        * Создает элемент навигации
        * @param {Object} sector - секция в которую вставляется элемент
        * @param {Int} i - индекс следующей секции
        */
        this.createNavigation = function (sector, i) {
            var next = blocks[i + 1];

            if (next !== undefined) {
                var nav = '<a class="wool-nav next" data-slide="' + (i + 1) + '"></a>',
                   el = this.createEl(nav);

                sector.appendChild(this.createEl(nav));
            }
        };
        /*
        * Переход к другой секции
        */
        this.changeSection = function () {
            var that = this,
                slide = that.getAttribute('data-slide'), 
                offset = blocks[slide].offsetTop;

                $('body, html').animate({ scrollTop: offset }, 1000, 'easeInSine');
            return false;
        };

        var vertical = this;
    };

    VerticalParalaxStr.prototype = Object.create(GetParalax.prototype);

    $.fn.woolParalax = function (options) {
        //Дефолтовые настройки
        var defOption = {
            'type': 'none', //none, horizont, vertical
            'layerNav': true,
            'layerClass': '.wool-layer',
            'differentSides': true//Если установлено в true то четные и нечетные слои будут двигаться в разные чтороны
        };

        $.extend(defOption, options);

        return this.each(function () {

            switch (defOption.type) {
                case 'none':
                    var paralax = new Paralax(new BaseParalaxStr());
                    paralax.start(this, defOption);
                    break;
                case 'vertical':
                    var paralax = new Paralax(new VerticalParalaxStr());
                    paralax.start(this, defOption);
                    break;
            }
        });
    }
} (jQuery));