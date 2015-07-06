$(".nav li").mouseover(function () {
      $(this).siblings().addClass("fade");
  }).mouseout(function () {
      $(this).siblings().removeClass("fade");
});
