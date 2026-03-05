# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  MR-ByteZ Fish ulimit-Workaround                                           ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:        shared/etc/fish/conf.d/010-ulimits.fish                       ║
# ║  Autor:       MR-ByteZ                                                      ║
# ║  Version:     0.1.0                                                         ║
# ║  Erstellt:    2026-03-05                                                    ║
# ║  Zweck:       Soft-Limit auf Hard-Limit hochziehen (Arch Linux SSH-Login    ║
# ║               setzt Soft trotz PAM limits.d + systemd DefaultLimitNOFILE    ║
# ║               nur auf 1024)                                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

ulimit -Sn 65536
