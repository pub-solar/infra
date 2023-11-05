{ config, ... }: extraOptions: {
  timerConfig = {
    OnCalendar = "*-*-* 02:00:00 Etc/UTC";
    # droppie will be offline if nachtigall misses the timer
    Persistent = false;
  };
  initialize = true;
  passwordFile = config.age.secrets."restic-repo-droppie".path;
  repository = "yule@droppie.b12f.io:/media/internal/backups-pub-solar";
} // extraOptions
