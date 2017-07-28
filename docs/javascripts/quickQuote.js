      /*script for dropdown on video*/
      document.getElementById('videoQuoteText-id-n').onclick = function() {
          if (document.getElementById('video-wrap-n').classList.contains('video-wrap--closed')) {
              document.getElementById('video-wrap-n').classList.remove('video-wrap--closed');
             document.getElementById('video-quote').play();
          } else {
              document.getElementById('video-wrap-n').classList.add('video-wrap--closed');
                document.getElementById('video-quote').pause();
          }
      };

