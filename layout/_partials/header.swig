<div class="site-brand-wrapper">
  <div class="site-meta {% if theme.custom_logo.enabled %}custom-logo{% endif %}">
    {% if theme.custom_logo.image and theme.scheme === 'Muse' %}
      <div class="site-meta-headline">
        <a>
          <img class="custom-logo-image" src="{{ theme.custom_logo.image }}"
               alt="{{ config.title }}"/>
        </a>
      </div>
    {% endif %}

  <!-- modify by zhangwei -->
  <!-- 下雪的动画 -->
  <div class="canvas-snow">
    <canvas id="canvas" style="margin: 0;  padding: 0;top:0; left: 0; right: 0; background: transparent; position: absolute;" width="1366" height="105"></canvas>
      <script>

      var canvasBgImg = {
        start: function () {
          this.canvas = document.getElementById('canvas')
          this.ctx = this.canvas.getContext("2d")
          this.canvas.width = window.innerWidth
          this.canvas.height = 105
          this.starList = []
        },
        drawLine: function (ctx, x1, y1, x2, y2) {
          ctx.beginPath()
          ctx.strokeStyle = '#ffffff'
          ctx.lineTo(x1, y1)
          ctx.lineTo(x2, y2)
          ctx.stroke()
        },
        canvasSingleSnow: function (snowSize) {
          var singleSnow = document.createElement('canvas'),
            ctxSingle = singleSnow.getContext('2d')
          singleSnow.setAttribute('width', snowSize * 2)
          singleSnow.setAttribute('height', snowSize * 2)
          for (var i = 0; i < 6; i++) {
            ctxSingle.save()
            ctxSingle.translate(snowSize, snowSize)
            ctxSingle.rotate(Math.PI * 2 * i / 6)
            this.drawLine(ctxSingle, 0, 0, snowSize, 0)
            ctxSingle.restore()
          }
          return singleSnow
        },
        canvasAllSnow: function (centerSnow) {
          var canvasSnow = document.createElement('canvas'),
            ctxSnow = canvasSnow.getContext('2d'),
            bigSnow = this.canvasSingleSnow(centerSnow),
            smallSnow = this.canvasSingleSnow(centerSnow / 3),
            sizeSnow = centerSnow * 3 / 5,
            rSnow = centerSnow - sizeSnow / 2
          canvasSnow.setAttribute('width', centerSnow * 2)
          canvasSnow.setAttribute('height', centerSnow * 2)
          ctxSnow.drawImage(bigSnow, 0, 0, bigSnow.width, bigSnow.height, 0, 0, centerSnow * 2, centerSnow * 2)
          for (var i = 0; i < 6; i++) {
            ctxSnow.save()
            ctxSnow.translate(centerSnow, centerSnow)
            ctxSnow.rotate(Math.PI * 2 * i / 6)
            ctxSnow.drawImage(smallSnow, 0, 0, smallSnow.width, smallSnow.height, rSnow - sizeSnow / 2,
              -sizeSnow / 2, sizeSnow, sizeSnow)
            ctxSnow.restore()
          }
          return canvasSnow
        },
        init: function () {
          this.start()
          for (var i = 0; i < 75; i++) {
            this.starList.push({
              drawFunc: this.canvasAllSnow(15),
              width: Math.random() * this.canvas.width,
              height: Math.random() * this.canvas.height,
              speed: Math.random() * 1.5 + .5,
              scale: Math.random() * 12 + 5,
              angel: 0
            })
          }
          var self = this,
            loop = function () {
              self.ctx.clearRect(0, 0, self.canvas.width, self.canvas.width)
              for (var i = 0; i < 75; i++) {
                self.ctx.save()
                self.starList[i].height = self.starList[i].height + self.starList[i].speed
                self.starList[i].angel += 2
                self.ctx.translate(self.starList[i].width, self.starList[i].height)
                self.ctx.rotate(self.starList[i].angel * Math.PI / 360)
                self.ctx.translate(-self.starList[i].width, -self.starList[i].height)
                self.ctx.drawImage(self.starList[i].drawFunc, 0, 0,
                  self.starList[i].drawFunc.width, self.starList[i].drawFunc.height,
                  self.starList[i].width - self.starList[i].scale / 2,
                  self.starList[i].height - self.starList[i].scale / 2,
                  self.starList[i].scale, self.starList[i].scale)
                if (self.starList[i].height > self.canvas.height) {
                  self.starList[i] = Object.assign(self.starList[i], {
                    height: -self.starList[i].scale,
                    width: Math.random() * this.canvas.width
                  })
                }
                self.ctx.restore()
              }
              requestAnimationFrame(loop)
            }
          requestAnimationFrame(loop)
        }
      }
      canvasBgImg.init()
      </script>

    </div>


    <div class="custom-logo-site-title">
      <a href="{{ config.root }}"  class="brand" rel="start">
        <!-- modify by zhangwei -->
        <!-- 圣诞帽 -->
        <img src="uploads/santa-hat.png" id="santa" style="height: 41px; position: absolute; left: -40px; top: -20px; transform: rotate(-45deg); z-index: 9000;">

        <span class="logo-line-before"><i></i></span>
        <span class="site-title">{{ config.title }}</span>
        <span class="logo-line-after"><i></i></span>
      </a>
    </div>
      {% if theme.seo %}
        <h1 class="site-subtitle" itemprop="description">{{ config.subtitle }}</h1>
      {% else %}
        <p class="site-subtitle">{{ config.subtitle }}</p>
      {% endif %}
  </div>

  <div class="site-nav-toggle">
    <button>
      <span class="btn-bar"></span>
      <span class="btn-bar"></span>
      <span class="btn-bar"></span>
    </button>
  </div>
</div>

<nav class="site-nav">
  {% set hasSearch = theme.swiftype_key || theme.algolia_search.enable || theme.tinysou_Key || theme.local_search.enable %}

  {% if theme.menu %}
    <ul id="menu" class="menu">
      {% for name, path in theme.menu %}
        {% set itemName = name.toLowerCase() %}
        <li class="menu-item menu-item-{{ itemName | replace(' ', '-') }}">
          <a href="{{ url_for(path.split('||')[0]) | trim }}" rel="section">
            {% if theme.menu_icons.enable %}
              <i class="menu-item-icon fa fa-fw fa-{{ path.split('||')[1] | trim | default('question-circle') }}"></i> <br />
            {% endif %}
            {{ __('menu.' + name) | replace('menu.', '') }}
          </a>
        </li>
      {% endfor %}

      {% if hasSearch %}
        <li class="menu-item menu-item-search">
          {% if theme.swiftype_key %}
            <a href="javascript:;" class="st-search-show-outputs">
          {% elseif theme.local_search.enable || theme.algolia_search.enable %}
            <a href="javascript:;" class="popup-trigger">
          {% endif %}
            {% if theme.menu_icons.enable %}
              <i class="menu-item-icon fa fa-search fa-fw"></i> <br />
            {% endif %}
            {{ __('menu.search') }}
          </a>
        </li>
      {% endif %}
    </ul>
  {% endif %}

  {% if hasSearch %}
    <div class="site-search">
      {% include 'search.swig' %}
    </div>
  {% endif %}
</nav>

{% include '../_custom/header.swig' %}
