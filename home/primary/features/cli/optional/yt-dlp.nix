{
  programs.yt-dlp = {
    enable = true;
    settings = {
      format = ''"bestvideo[height<=1080]+bestaudio/best[height<=1080]"'';
      throttled-rate = "70K";
      output = ''"%(title)s"'';
    };
  };
}
