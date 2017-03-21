rem perl gmatav2.1.pl -c default_cfg.txt -i "D:\Downloads\nic_SSR\nsyl.scaf.fa"
echo "started SSR mining"
echo %time% >time.log
perl gmat.pl -i "C:\binv21rel\ptaeda\pitav101.scfld.fa" -m 2 -x 6 -r 5

echo %time% >>time.log
echo "ended SSR mining"

pause