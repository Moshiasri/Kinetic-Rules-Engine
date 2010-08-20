{"global":[{"source":"http://aaa-demo.s3.amazonaws.com/aaa.json","name":"aaa","type":"dataset","datatype":"JSON","cachable":1},{"source":"http://aaa-demo.s3.amazonaws.com/aaawa.json","name":"aaawa","type":"dataset","datatype":"JSON","cachable":1},{"content":"#spotlight-reminders-wrapper {\n          height:24px;\n          background:#e4effd;\n          font-size:small;\n          margin:15px 0;\n          padding:0 0 0 9px;\n          }\n          \n          .remindme-reminders-wrapper {\n          height:24px;\n          background:#FFF;\n          font-size:small;\n          width:450px;\n          margin:0;\n          padding:0;\n          }\n          \n          p.descriptive-text {\n          float:right;\n          color:#7a7a7a;\n          font-size:small;\n          margin:4px 9px 0 0;\n          padding:0;\n          }\n          \n          ul.spotlightReminders {\n          float:left;\n          list-style:none;\n          height:24px;\n          margin:0;\n          padding:0;\n          }\n          \n          ul.spotlightReminders li {\n          display:block;\n          float:left!important;\n          margin:3px 3px 0 0;\n          }\n          \n          ul.spotlightReminders li.azigo-logo {\n          margin:4px 0 0;\n          }\n          \n          ul.spotlightReminders li.txt-reminder {\n          color:#2b30d1;\n          margin:4px 3px 0 0;\n          padding:0 0 0 4px;\n          }\n          \n          .clear {\n          clear:both;\n          }\n          \n          .remindme-flyout-wrapper {\n          border:3px solid #e471ac;\n          width:450px;\n          position:absolute;\n          background-color:#FFF;\n          display:none;\n          z-index:1;\n          text-align:left;\n          margin:0 0 0 20px;\n          }\n          \n          .flyout-pointer {\n          background:url(http:\\/\\/aaa-demo.s3.amazonaws.com/FlyoutPoint.png) no-repeat;\n          height:11px;\n          width:15px;\n          position:relative;\n          margin:-11px 0 0 20px;\n          }\n          \n          .flyout-reminder-details {\n          color:#000;\n          float:left;\n          border-bottom:1px solid #c2c2c2;\n          font-size:small;\n          width:430px;\n          padding:8px 10px;\n          }\n          \n          p.flyout-reminder-url {\n          margin:0 0 5px;\n          padding:0;\n          }\n          \n          .flyout-reminder-details ul {\n          list-style:none;\n          line-height:14px;\n          margin:0;\n          padding:0;\n          }\n          \n          .flyout-reminder-details ul li {\n          display:block;\n          float:left!important;\n          margin:0 4px 0 0;\n          padding:0;\n          }\n          \n          .flyout-reminder-details ul li.flyout-reminder-url {\n          width:250px;\n          margin:0 0 5px;\n          padding:0;\n          }\n          \n          .flyout-reminder-details ul li.flyout-reminder-text {\n          width:230px;\n          }\n          \n          .flyout-reminder-details ul li.flyout-reminder-button {\n          margin:0;\n          }\n          \n          a.flyout-reminder-button {\n          display:block;\n          font-size:10px;\n          font-weight:700;\n          font-family:Verdana, sans-serif, Arial, Helvetica;\n          background:#57b6e3;\n          text-align:center;\n          text-decoration:none;\n          height:16px;\n          width:96px;\n          color:#fff;\n          margin:0;\n          padding:2px 0 0;\n          }\n          \n          .clearfix:after {\n          content:\".\";\n          display:block;\n          clear:both;\n          visibility:hidden;\n          line-height:0;\n          height:0;\n          }\n          \n          .clearfix {\n          display:inline-block;\n          }\n          \n          html[xmlns] .clearfix {\n          display:block;\n          }\n          \n          * html .clearfix {\n          height:1%;\n          }\n          \n          .flyout-wrapper {\n          border:3px solid #e471ac;\n          width:450px;\n          position:absolute;\n          background-color:#FFF;\n          display:none;\n          z-index:1;\n          margin:-15px 0 0 29px;\n          }\n        ","type":"css"},{"emit":"var globalData = {\n              \"Source\": \"aaaw\",\n              \"RemindMeIconUrl\": \"http://aaa-demo.s3.amazonaws.com/aaa_18x24.png\",\n              \"FlyoutIconUrl\": \"http://aaa-demo.s3.amazonaws.com/aaa_60x90.png\"\n          };\n          \n          function remindMeSelector(obj) {\n              var annotationContent;\n              var remindMeDomain = obj.name.replace(/http:\\/\\/([A-Za-z0-9.-]+)\\/.*/, \"$1\");\n              remindMeDomain = remindMeDomain.replace(\"http://\", \"\");\n              remindMeDomain = remindMeDomain.replace(\"www.\", \"\");\n              remindMeDomain = remindMeDomain.replace(\"www1.\", \"\");\n              remindMeDomain = remindMeDomain.replace(/\\.[^.]+$/, \"\");\n              remindMeDomain = remindMeDomain.replace(/[&]/g, \"and\");\n              remindMeDomain = remindMeDomain.replace(/\\s+/g, \"\");\n              remindMeDomain = remindMeDomain.replace(/[\"'\"]/g, \"\");\n              remindMeDomain = remindMeDomain.replace(/[-]/g, \"\");\n              remindMeDomain = remindMeDomain.toLowerCase();\n              var remindMeDivId = \"remindMe_\" + remindMeDomain;\n              var remindMeFlyoutDivId = \"remindMeFlyout_\" + remindMeDomain;\n              var remindMeWrapper = \"remindMeWrapper_\" + remindMeDomain;\n              if ($K(\"#\" + remindMeDivId).length == 0) {\n                  var remindMeMainDiv = createRemindMeDiv(remindMeDivId);\n                  var remindMeFlyoutDiv = createRemindMeFlyoutDiv(remindMeFlyoutDivId);\n                  remindMeFlyoutDiv.append(getFlyoutDetails(obj.name, obj.link, globalData.FlyoutIconUrl, obj.text, obj.icon));\n                  var remindMeDiv = $K(\"<div></div>\");\n                  var wrapperDiv = $K(\"<div id='\" + remindMeWrapper + \"' class='remindme-reminders-wrapper'></div>\");\n                  wrapperDiv.append(remindMeMainDiv);\n                  remindMeDiv.append(wrapperDiv);\n                  remindMeDiv.append(remindMeFlyoutDiv);\n                  annotationContent = remindMeDiv;\n                  registerEvents(remindMeDivId, remindMeFlyoutDivId, false);\n              } else {\n                  if ($K(\"#\" + remindMeDivId).find(\"#img_\" + globalData.Source + \"_remindMe\").length) {\n                      return false;\n                  }\n                  if ($K(\"#\" + remindMeDivId).children(\".txt-reminder\").length) {\n                      $K(\"#\" + remindMeDivId).children(\".txt-reminder\").after(makeListItem(null, null, $K(\"<img id='img_\" + globalData.Source + \"_remindMe' src='\" + globalData.RemindMeIconUrl + \"' />\")));\n                  }\n                  if ($K(\"#\" + remindMeFlyoutDivId).length) {\n                      $K(\"#\" + remindMeFlyoutDivId).append(getFlyoutDetails(obj.name, obj.link, globalData.FlyoutIconUrl, obj.text, obj.icon));\n                  }\n                  var spanReminders = $K(\"#\" + remindMeDivId).children(\".txt-reminder\").children(\".spanRemindMeNReminders\");\n                  if (spanReminders.length > 0) {\n                      var totalReminders = parseInt(spanReminders.text());\n                      if (!isNaN(totalReminders)) {\n                          totalReminders = totalReminders + 1;\n                          spanReminders.text(String(totalReminders));\n                          if (totalReminders == 1) {\n                              $K(\"#\" + remindMeDivId).children(\".txt-reminder\").children(\".spanRemindMeTextReminders\").text(\"Reminder\");\n                          } else {\n                              $K(\"#\" + remindMeDivId).children(\".txt-reminder\").children(\".spanRemindMeTextReminders\").text(\"Reminders\");\n                          }\n                      }\n                  }\n                  annotationContent = false;\n              }\n              return annotationContent;\n          }\n          function registerEvents(remindMeDivId, remindMeFlyoutDivId, isSpotlightEvent) {\n              $K(\"#\" + remindMeDivId).live('mouseover', function () {\n                  $K(\"#\" + remindMeDivId).css({\n                      'cursor': 'hand',\n                      'cursor': 'pointer'\n                  });\n                  $K(\"#\" + remindMeFlyoutDivId).show();\n              });\n              $K(\"#\" + remindMeDivId).live('mouseout', function () {\n                  if (isSpotlightEvent) {\n                      $K(\"#spotlight-reminders-wrapper\").live('mouseover', function () {\n                          $K(\"#\" + remindMeFlyoutDivId).show();\n                      });\n                      $K(\"#spotlight-reminders-wrapper\").live('mouseout', function () {\n                          $K(\"#\" + remindMeFlyoutDivId).hide();\n                          $K(\"#spotlight-reminders-wrapper\").die('mouseover');\n                          $K(\"#spotlight-reminders-wrapper\").die('mouseout');\n                      });\n                  } else {\n                      $K(\"#\" + remindMeDivId).parent().mouseover(function () {\n                          $K(\"#\" + remindMeFlyoutDivId).show();\n                      });\n                      $K(\"#\" + remindMeDivId).parent().mouseout(function () {\n                          $K(\"#\" + remindMeFlyoutDivId).hide();\n                          $K(\"#\" + remindMeDivId).parent().unbind('mouseover');\n                          $K(\"#\" + remindMeDivId).parent().unbind('mouseout');\n                      });\n                  }\n                  $K(\"#\" + remindMeFlyoutDivId).hide();\n              });\n              $K(\"#\" + remindMeFlyoutDivId).live('mouseover', function () {\n                  $K(\"#\" + remindMeFlyoutDivId).show();\n              });\n              $K(\"#\" + remindMeFlyoutDivId).live('mouseout', function () {\n                  $K(\"#\" + remindMeFlyoutDivId).hide();\n                  if (isSpotlightEvent) {\n                      $K(\"#spotlight-reminders-wrapper\").die('mouseover');\n                      $K(\"#spotlight-reminders-wrapper\").die('mouseout');\n                  } else {\n                      $K(\"#\" + remindMeDivId).parent().unbind('mouseover');\n                      $K(\"#\" + remindMeDivId).parent().unbind('mouseout');\n                  }\n              });\n          }\n          function createRemindMeDiv(remindMeDivId) {\n              var remindMeMainUl = $K(\"<ul></ul>\");\n              remindMeMainUl.attr({\n                  \"id\": remindMeDivId,\n                  \"class\": \"spotlightReminders\"\n              });\n              remindMeMainUl.append(makeListItem(null, \"azigo-logo\", $K(\"<img src='http:\\/\\/aaa-demo.s3.amazonaws.com/azigo_16x16.png' />\")));\n              remindMeMainUl.append(makeListItem(\"remindme-txt-reminder\", \"txt-reminder\", \"<span class='spanRemindMeNReminders'>1</span> <span class='spanRemindMeTextReminders'>Reminder</span>\"));\n              remindMeMainUl.append(makeListItem(null, null, $K(\"<img id='img_\" + globalData.Source + \"_remindMe' src='\" + globalData.RemindMeIconUrl + \"' />\")));\n              remindMeMainUl.append(makeListItem(null, null, $K(\"<img src='http:\\/\\/aaa-demo.s3.amazonaws.com/FlyoutIndicator.png' />\")));\n              return remindMeMainUl;\n          }\n          function createRemindMeFlyoutDiv(remindMeFlyoutDivId) {\n              var remindMeFlyoutDiv = $K(\"<div></div>\");\n              remindMeFlyoutDiv.attr({\n                  \"id\": remindMeFlyoutDivId,\n                  \"class\": \"remindme-flyout-wrapper\"\n              });\n              remindMeFlyoutDiv.append($K(\"<div></div>\").attr(\"class\", \"flyout-pointer\"));\n              return remindMeFlyoutDiv;\n          }\n          function makeListItem(listItemId, listItemClass, listItemContent) {\n              var listItem = $K(\"<li></li>\");\n              if (listItemClass != null) {\n                  listItem.attr(\"class\", listItemClass);\n              }\n              if (listItemId != null) {\n                  listItem.attr(\"id\", listItemId);\n              }\n              listItem.append(listItemContent);\n              return listItem;\n          }\n          function makeAnchorTag(aUrl, aClass, aText) {\n              var anchorTag = $K(\"<a></a>\");\n              anchorTag.attr(\"href\", aUrl);\n              if (aClass != null) {\n                  anchorTag.attr(\"class\", aClass);\n              }\n              anchorTag.append(aText);\n              return anchorTag;\n          }\n          function getFlyoutDetails(clientName, clientUrl, clientLogo, displayText, buttonType) {\n              var flyoutDetailsDiv = $K(\"<div></div>\");\n              flyoutDetailsDiv.attr(\"class\", \"flyout-reminder-details clearfix\");\n              var flyoutDetailsUl = $K(\"<ul></ul>\");\n              flyoutDetailsUl.append(makeListItem(null, null, $K(\"<img src='\" + clientLogo + \"' />\")));\n              flyoutDetailsUl.append(makeListItem(null, \"flyout-reminder-url\", makeAnchorTag(clientUrl, null, clientName)));\n              flyoutDetailsUl.append(makeListItem(null, \"flyout-reminder-text\", displayText));\n              var discountButton = \"\";\n              discountButton = makeAnchorTag(clientUrl, \"flyout-reminder-button\", \"Click and Save\");\n              flyoutDetailsUl.append(makeListItem(null, null, discountButton));\n              flyoutDetailsDiv.append(flyoutDetailsUl);\n              return flyoutDetailsDiv;\n          }\n          KOBJ.spotlight = function (source) {\n              function datasetcallback(d) {\n                  if (d) {\n                      var response = d.response;\n                      if (response) {\n                          if (response.docs.length > 0) {\n                              displaySpotlight(response);\n                          }\n                      }\n                  }\n              }\n              var q = String(top.location).replace(/^.*[\\?&][qp]=([^&]+).*$/, \"$1\");\n              var remoteUrl = \"http://service.azigo.com/solr/nutchfilter.jsp?q=\" + q + \"&fq=source:\" + source + \"&callback=?\";\n              $K.getJSON(remoteUrl, datasetcallback);\n          \n              function createSpotlightMainDiv() {\n                  var spotlightMainDiv = $K(\"<div></div>\");\n                  spotlightMainDiv.attr(\"id\", \"spotlight-reminders-wrapper\");\n                  var spotlightMainUl = $K(\"<ul></ul>\");\n                  spotlightMainUl.attr({\n                      \"id\": \"spotlightReminders\",\n                      \"class\": \"spotlightReminders\"\n                  });\n                  spotlightMainUl.append(makeListItem(null, 'azigo-logo', $K(\"<img src='http:\\/\\/aaa-demo.s3.amazonaws.com/azigo_16x16.png' />\")));\n                  var spotlightReminderNSpan = $K(\"<span></span>\");\n                  spotlightReminderNSpan.attr(\"id\", \"spanNReminders\");\n                  spotlightReminderNSpan.text(\"0\");\n                  var spotlightReminderTextSpan = $K(\"<span></span>\");\n                  spotlightReminderTextSpan.attr(\"id\", \"spanTextReminders\");\n                  spotlightReminderTextSpan.text(\"Reminders\");\n                  spotlightMainUl.append(makeListItem(\"spotlight-txt-reminder\", \"txt-reminder\", \"<span id='spanNReminders'>0</span> <span id='spanTextReminders'>Reminders</span>\"));\n                  spotlightMainUl.append(makeListItem(null, null, $K(\"<img src='http:\\/\\/aaa-demo.s3.amazonaws.com/FlyoutIndicator.png' />\")));\n                  var spotlightMainP = $K(\"<p></p>\");\n                  spotlightMainP.attr(\"class\", \"descriptive-text\");\n                  spotlightMainP.text(\"My Sponsored Links\");\n                  spotlightMainDiv.append(spotlightMainUl);\n                  spotlightMainDiv.append(spotlightMainP);\n                  return spotlightMainDiv;\n              }\n              function createSpotlightFlyoutDiv() {\n                  var spotlightFlyoutDiv = $K(\"<div></div>\");\n                  spotlightFlyoutDiv.attr({\n                      \"id\": \"spotlightFlyoutDiv\",\n                      \"class\": \"flyout-wrapper\"\n                  });\n                  spotlightFlyoutDiv.append($K(\"<div></div>\").attr(\"class\", \"flyout-pointer\"));\n                  return spotlightFlyoutDiv;\n              }\n              function flyoutContentCallback(data) {\n                  if ($K('#spotlightFlyoutDiv').length) {\n                      $K.each(data, function () {\n                          $K('#spotlightFlyoutDiv').append(getFlyoutDetails(this.name, this.link, globalData.FlyoutIconUrl, this.text, this.icon));\n                      });\n                  }\n              }\n              function displaySpotlight(response) {\n                  var logoUrl = globalData.RemindMeIconUrl;\n                  if ($K(\"#spotlight-reminders-wrapper\").length == 0) {\n                      var spotlightMainDiv = createSpotlightMainDiv();\n                      var spotlightFlyoutDiv = createSpotlightFlyoutDiv();\n                      var spotlightDiv = $K(\"<div id='spotlight-main-flyout'></div>\");\n                      spotlightDiv.append(spotlightMainDiv);\n                      spotlightDiv.append(spotlightFlyoutDiv);\n                      if ($K(\"#res\").length) {\n                          $K(\"#res\").prepend(spotlightDiv);\n                      } else if ($K(\"#web\").length) {\n                          $K(\"#web\").prepend(spotlightDiv);\n                      } else if ($K(\"#results\").length) {\n                          $K(\"#results\").prepend(spotlightDiv);\n                      }\n                  }\n                  registerEvents(\"spotlightReminders\", \"spotlightFlyoutDiv\", true);\n                  if ($K(\"#img_\" + source + \"_spotlight\").length) {\n                      return;\n                  }\n                  if ($K(\"#spotlight-txt-reminder\").length) {\n                      $K(\"#spotlight-txt-reminder\").after(\"<li><img id='img_\" + source + \"_spotlight' src='\" + logoUrl + \"' /></li>\");\n                  }\n                  var spanReminders = $K(\"#spanNReminders\");\n                  if (spanReminders.length > 0) {\n                      var totalReminders = parseInt(spanReminders.text());\n                      if (!isNaN(totalReminders)) {\n                          if (response.docs.length > 3) {\n                              totalReminders = totalReminders + 3;\n                          } else {\n                              totalReminders = totalReminders + response.docs.length;\n                          }\n                          spanReminders.text(String(totalReminders));\n                          if (totalReminders == 1) {\n                              $K(\"#spanTextReminders\").text(\"Reminder\");\n                          } else {\n                              $K(\"#spanTextReminders\").text(\"Reminders\");\n                          }\n                      }\n                  }\n                  var jsonData = \"\";\n                  var index = 1;\n                  $K.each(response.docs, function () {\n                      if (index > 1) jsonData += \",\";\n                      jsonData += \"'KOBJL\" + index + \"':{'url':'\" + this.url + \"'}\";\n                      index++;\n                      if (index > 3) return false;\n                  });\n                  var jsonUrl = \"https://service.azigo.com/remindmeac/fetch?callback=?&jsonData=true&source=\" + source;\n                  $K.getJSON(jsonUrl, \"annotatedata={\" + jsonData + \"}\", flyoutContentCallback);\n              }\n          };        \n   \n      "},{"emit":"var url_prefix = \"http://aaa-demo.s3.amazonaws.com/\";\n          var link_text = {\n              \"aaa\": \"<div style='padding-top: 13px'>AAA</div>\",\n              \"aarp\": \"<div style='padding-top: 13px'>AARP</div>\",\n              \"aarp_img\": \"<img style='padding-top: 3px' src='\" + url_prefix + \"aarp_logo_34.png' border='0'>\",\n              \"amex\": \"<div style='padding-top: 5px'>American<br/>Express</div>\",\n              \"bcc\": \"<img style='padding-top: 5px' src='\" + url_prefix + \"bcc_logo_34.png' border='0'>\",\n              \"ebates\": \"<img style='padding-top: 7px;height:28px' src='\" + url_prefix + \"ebates_logo_34.png' border='0'>\",\n              \"lemay\": \"<img style='padding-top: 7px' src='\" + url_prefix + \"lemay_logo_25.png' border='0'>\",\n              \"mod_text\": \"<div style='padding-top: 13px'>MoD</div>\",\n              \"mod\": \"<img style='padding-top: 3px' src='\" + url_prefix + \"mod_logo_34.png' border='0' >\",\n              \"sadv\": \"<img style='padding-top: 3px' src='\" + url_prefix + \"sadv_logo_34.png' border='0' >\",\n              \"sadv_txt\": \"<div style='padding-top: 7px'>Student<br/>Advantage</div>\",\n              \"upromise\": \"<div style='padding-top: 13px'>UPromise</div>\",\n              \"boa\": \"<img style='padding-top: 3px' src='\" + url_prefix + \"boa_logo_34.png' border='0'>\",\n              \"sep\": \"<div style='padding-top: 13px'>|</div>\",\n              \"aaawa_text\": \"<div style='padding-top: 13px'>AAA</div>\",\n              \"aaawa\": \"<img style='padding-top: 5px' src='\" + url_prefix + \"aaa_logo_34.png' border='0'>\"\n          };\n          \n          function make_selector(key) {\n              var func = function (obj) {\n                  try {\n                      function mk_anchor(o, key) {\n                          return $K('<a href=' + o.link + '/>').attr({\n                              \"class\": 'KOBJ_' + key,\n                              \"title\": o.text || \"Click here for discounts!\"\n                          }).html(link_text[key]);\n                      }\n                      var entryURL = $K(obj).find(\"span.url, cite\").text();\n                      var host = KOBJ.get_host(entryURL);\n                      var o = KOBJ.pick(KOBJ['data'][key][host]);\n                      if (!o) {\n                          o = KOBJ.pick(KOBJ['data'][key][\"www.\" + host]);\n                      }\n                      if (!o) {\n                          o = KOBJ.pick(KOBJ['data'][key][host.replace(/^www./, \"\")]);\n                      }\n                      if (key == 'aaawa' && host == 'www.premiumoutlets.com') {\n                          if (!entryURL.match(/^www\\.premiumoutlets\\.com(\\/seattle|\\/ |$)/)) {\n                              return false;\n                          }\n                      }\n                      if (key == 'aaawa' && host == 'www.diamondparking.com') {\n                          if (!entryURL.match(/^www\\.diamondparking\\.com\\/Airport\\/Spokane.aspx/)) {\n                              return false;\n                          }\n                      }\n                      if (o) {\n                          return mk_anchor(o, key);\n                      } else {\n                          return false;\n                      }\n                  } catch (e) {\n                      var txt = \"_s=1d895cc0802263e1c523349091752b25&_r=img\";\n                      txt += \"&Msg=\" + escape(e.message ? e.message : e);\n                      txt += \"&URL=\" + escape(e.fileName ? e.fileName : \"\");\n                      txt += \"&Line=\" + (e.lineNumber ? e.lineNumber : 0);\n                      txt += \"&name=\" + escape(e.name ? e.name : e);\n                      txt += \"&Platform=\" + escape(navigator.platform);\n                      txt += \"&UserAgent=\" + escape(navigator.userAgent);\n                      txt += \"&stack=\" + escape(e.stack ? e.stack : \"\");\n                      var i = document.createElement(\"img\");\n                      i.setAttribute(\"src\", \"http://www.errorstack.com/submit?\" + txt);\n                      document.body.appendChild(i);\n                  }\n              };\n              return func;\n          }\n          function make_selector_exact_match(key) {\n              var func = function (obj) {\n                  try {\n                      function mk_anchor(o, key) {\n                          return $K('<a href=' + o.link + '/>').attr({\n                              \"class\": 'KOBJ_' + key,\n                              \"title\": o.text || \"Click here for discounts!\"\n                          }).html(link_text[key]);\n                      }\n                      var otherURL = $K(obj).find(\"span.url, cite\").text();\n                      var entryURL = $K(obj).find(\"span.url, cite\").text().replace(/\\s+.*$/, \"\").replace(/\\/$/, \"\").replace(/^www\\./, \"\").toLowerCase();\n                      var o = KOBJ.pick(KOBJ['data'][key][entryURL]);\n                      if (o) {\n                          return mk_anchor(o, key);\n                      } else {\n                          return false;\n                      }\n                  } catch (e) {\n                      var txt = \"_s=1d895cc0802263e1c523349091752b25&_r=img\";\n                      txt += \"&Msg=\" + escape(e.message ? e.message : e);\n                      txt += \"&URL=\" + escape(e.fileName ? e.fileName : \"\");\n                      txt += \"&Line=\" + (e.lineNumber ? e.lineNumber : 0);\n                      txt += \"&name=\" + escape(e.name ? e.name : e);\n                      txt += \"&Platform=\" + escape(navigator.platform);\n                      txt += \"&UserAgent=\" + escape(navigator.userAgent);\n                      txt += \"&stack=\" + escape(e.stack ? e.stack : \"\");\n                      var i = document.createElement(\"img\");\n                      i.setAttribute(\"src\", \"http://www.errorstack.com/submit?\" + txt);\n                      document.body.appendChild(i);\n                  }\n              };\n              return func;\n          }\n          aaa_selector = make_selector('aaa');\n          aarp_selector = make_selector('aarp');\n          amex_selector = make_selector('amex');\n          ebates_selector = make_selector('ebates');\n          lemay_selector = make_selector('lemay');\n          mod_selector = make_selector('mod');\n          sadv_selector = make_selector('sadv');\n          upromise_selector = make_selector('upromise');\n          aaawa_selector = make_selector_exact_match('aaawa');\n          \n          function get_host(s) {\n              var h = \"\";\n              try {\n                  h = s.match(/^(?:\\w+:\\/\\/)?([\\w.]+)/)[1];\n              } catch (err) {}\n              return h;\n          }\n          function pick(o) {\n              if (o) {\n                  return o[Math.floor(Math.random() * o.length)];\n              } else {\n                  return o;\n              }\n          }        \n\n       "}],"global_start_line":18,"dispatch":[{"domain":"www.google.com","ruleset_id":null},{"domain":"maps.google.com","ruleset_id":null},{"domain":"search.yahoo.com","ruleset_id":null},{"domain":"local.yahoo.com","ruleset_id":null},{"domain":"www.bing.com","ruleset_id":null},{"domain":"search.microsoft.com","ruleset_id":null}],"dispatch_start_col":5,"meta_start_line":2,"rules":[{"cond":{"args":[{"source":"page","predicate":"param","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"(^|,)aaawa(,|$)","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"action":{"source":null,"name":"annotate_search_results","args":[{"val":"remindMeSelector","type":"var"}],"modifiers":[{"value":{"val":"http://aaa-demo.s3.amazonaws.com/aaawa-demo.json","type":"str"},"name":"remote"},{"value":{"val":[{"rhs":{"val":"none","type":"str"},"lhs":"float"},{"rhs":{"val":"0px","type":"str"},"lhs":"margin-left"},{"rhs":{"val":"0px","type":"str"},"lhs":"padding-right"}],"type":"hashraw"},"name":"outer_div_css"},{"value":{"val":[{"rhs":{"val":"0px","type":"str"},"lhs":"margin-left"},{"rhs":{"val":"0px","type":"str"},"lhs":"padding-right"},{"rhs":{"val":"5px","type":"str"},"lhs":"padding-top"}],"type":"hashraw"},"name":"inner_div_css"},{"value":{"val":[{"rhs":{"val":"0px","type":"str"},"lhs":"padding-left"},{"rhs":{"val":"normal","type":"str"},"lhs":"white-space"}],"type":"hashraw"},"name":"li_css"},{"value":{"val":"after","type":"str"},"name":"placement"},{"value":{"val":[{"rhs":{"val":[{"rhs":{"val":".sa_cc","type":"str"},"lhs":"modify"}],"type":"hashraw"},"lhs":"www.bing.com"}],"type":"hashraw"},"name":"domains"}],"vars":null},"label":null},{"action":{"source":null,"name":"annotate_local_search_results","args":[{"val":"remindMeSelector","type":"var"}],"modifiers":[{"value":{"val":"http://aaa-demo.s3.amazonaws.com/aaawa-demo.json","type":"str"},"name":"remote"},{"value":{"val":"after","type":"str"},"name":"placement"},{"value":{"val":[{"rhs":{"val":[{"rhs":{"val":".sc_ol1","type":"str"},"lhs":"modify"}],"type":"hashraw"},"lhs":"www.bing.com"}],"type":"hashraw"},"name":"domains"}],"vars":null},"label":null}],"post":null,"pre":[],"name":"aaa_newui_goolge","start_col":5,"emit":"","state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"flyout-reminder-button","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://www.google.com|^http://www.bing.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":580},{"cond":{"args":[{"source":"page","predicate":"param","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"(^|,)aaawa(,|$)","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"action":{"source":null,"name":"annotate_search_results","args":[{"val":"remindMeSelector","type":"var"}],"modifiers":[{"value":{"val":"http://aaa-demo.s3.amazonaws.com/aaawa-demo.json","type":"str"},"name":"remote"},{"value":{"val":[{"rhs":{"val":"none","type":"str"},"lhs":"float"},{"rhs":{"val":"40px","type":"str"},"lhs":"height"},{"rhs":{"val":"0px","type":"str"},"lhs":"margin-left"},{"rhs":{"val":"-10px","type":"str"},"lhs":"margin-top"},{"rhs":{"val":"0px","type":"str"},"lhs":"padding-right"}],"type":"hashraw"},"name":"outer_div_css"},{"value":{"val":[{"rhs":{"val":"0px","type":"str"},"lhs":"margin-left"},{"rhs":{"val":"0px","type":"str"},"lhs":"padding-right"}],"type":"hashraw"},"name":"inner_div_css"},{"value":{"val":[{"rhs":{"val":"0px","type":"str"},"lhs":"padding-left"},{"rhs":{"val":"normal","type":"str"},"lhs":"white-space"}],"type":"hashraw"},"name":"li_css"},{"value":{"val":"after","type":"str"},"name":"placement"},{"value":{"val":[{"rhs":{"val":[{"rhs":{"val":"#web > ol > li","type":"str"},"lhs":"selector"},{"rhs":{"val":"div.res","type":"str"},"lhs":"modify"}],"type":"hashraw"},"lhs":"search.yahoo.com"}],"type":"hashraw"},"name":"domains"}],"vars":null},"label":null},{"action":{"source":null,"name":"annotate_local_search_results","args":[{"val":"remindMeSelector","type":"var"}],"modifiers":[{"value":{"val":"http://aaa-demo.s3.amazonaws.com/aaawa-demo.json","type":"str"},"name":"remote"},{"value":{"val":"after","type":"str"},"name":"placement"},{"value":{"val":[{"rhs":{"val":[{"rhs":{"val":".qlmr","type":"str"},"lhs":"modify"}],"type":"hashraw"},"lhs":"search.yahoo.com"}],"type":"hashraw"},"name":"domains"}],"vars":null},"label":null}],"post":null,"pre":[],"name":"aaa_newui_yahoo","start_col":5,"emit":"","state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"flyout-reminder-button","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://search.yahoo.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":611},{"cond":{"args":[{"source":"page","predicate":"param","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"(^|,)aaawa(,|$)","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"KOBJ.spotlight('aaaw');                       \n          "}],"post":null,"pre":[],"name":"aaa_newui_spotlight","start_col":5,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"flyout-reminder-button","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://search.yahoo.com|^http://www.bing.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":642},{"cond":{"args":[{"source":"page","predicate":"param","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"(^|,)aaawa(,|$)","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"KOBJ.spotlight('aaaw');         \n               KOBJ.watchDOM(\"#rso\",function() {  \t\t\t\n               $K('#spotlight-main-flyout').remove();  \t\t\t\n               KOBJ.spotlight('aaaw');});                    \n            "}],"post":null,"pre":[],"name":"aaa_newui_spotlight_google","start_col":5,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"flyout-reminder-button","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://www.google.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":659}],"meta_start_col":5,"meta":{"logging":"on","name":"AAA Demo","meta_start_line":2,"description":"AAA Demo Application   \n","meta_start_col":5},"dispatch_start_line":10,"global_start_col":5,"ruleset_name":"a12x9"}
