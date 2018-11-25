1) написать свою реализацию ps ax используя анализ /proc
``` bash
>>> ./ps_ax.sh
```

2) написать свою реализацию lsof
``` bash
>>> ./lsof.sh
```

3) дописать обработчики сигналов в прилагаемом скрипте, оттестировать, приложить сам скрипт, инструкции по использованию
``` bash
>>> python fork.py
```
    - log: typescripts/typescript.fork

4) реализовать 2 конкурирующих процесса по IO. пробовать запустить с разными ionice
``` bash
>>> ./io_nice sh
```
    - log: typescripts/typescript.io_nice

5) реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice
``` bash
>>> ./nice_cpu.sh
```
    - log: typescripts/typescript.cpu_nice
