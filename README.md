How to reproduce:

```shell
git clone https://github.com/adrianrudnik/intl-segfault
cd intl-segfault
docker build -t intl-segfault .
docker run --rm -it -p 8080:80 intl-segfault
```

then open http://localhost:8080/ to trigger the following docker log entries:

```
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
[Fri Aug 04 14:21:41.749364 2023] [mpm_prefork:notice] [pid 1] AH00163: Apache/2.4.57 (Debian) PHP/8.2.8 configured -- resuming normal operations
[Fri Aug 04 14:21:41.749378 2023] [core:notice] [pid 1] AH00094: Command line: 'apache2 -D FOREGROUND'
[Fri Aug 04 14:21:49.783205 2023] [core:notice] [pid 1] AH00052: child pid 17 exit signal Segmentation fault (11)
```

`GDB` and coredumps are configured and should be debuggable with

```shell
cd /tmp
gdb /usr/sbin/apache2 /tmp/coredump-apache*
```

Output on my machine:

```
Program terminated with signal SIGSEGV, Segmentation fault.
#0  0x00007ff23043baad in _efree () from /usr/lib/apache2/modules/libphp.so
(gdb) bt
#0  0x00007ff23043baad in _efree () from /usr/lib/apache2/modules/libphp.so
#1  0x00007ff2314bb8d9 in intl_error_reset () from /usr/local/lib/php/extensions/no-debug-non-zts-20220829/intl.so
#2  0x00007ff2314f079e in ?? () from /usr/local/lib/php/extensions/no-debug-non-zts-20220829/intl.so
#3  0x00007ff2304bb7ed in zend_fe_fetch_object_helper_SPEC () from /usr/lib/apache2/modules/libphp.so
#4  0x00007ff2304d1fe4 in execute_ex () from /usr/lib/apache2/modules/libphp.so
#5  0x00007ff2304d54d3 in zend_execute () from /usr/lib/apache2/modules/libphp.so
#6  0x00007ff230465a08 in zend_execute_scripts () from /usr/lib/apache2/modules/libphp.so
#7  0x00007ff2304009fe in php_execute_script () from /usr/lib/apache2/modules/libphp.so
#8  0x00007ff230549388 in php_handler () from /usr/lib/apache2/modules/libphp.so
#9  0x0000559729934bf0 in ap_run_handler ()
#10 0x00005597299351d6 in ap_invoke_handler ()
#11 0x000055972994d747 in ap_process_async_request ()
#12 0x000055972994d94f in ap_process_request ()
#13 0x0000559729949a14 in ?? ()
#14 0x000055972993e8a0 in ap_run_process_connection ()
#15 0x00007ff232693ca4 in ?? () from /usr/lib/apache2/modules/mod_mpm_prefork.so
#16 0x00007ff232694027 in ?? () from /usr/lib/apache2/modules/mod_mpm_prefork.so
#17 0x00007ff232694089 in ?? () from /usr/lib/apache2/modules/mod_mpm_prefork.so
#18 0x00007ff2326947b3 in ?? () from /usr/lib/apache2/modules/mod_mpm_prefork.so
#19 0x0000559729915640 in ap_run_mpm ()
#20 0x000055972990d16a in main ()
```
