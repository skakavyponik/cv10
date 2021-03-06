% program na hladanie kociek robotom v bludisku s prekazkami,
% robot ma 3 snimace prekazok (vpredu, vlavo, vpravo), otaca sa o 90stupnov
% vlavo alebo vpravo, ide iba dopredu
% cielom je najst vsetky kocky v bludisku, po najdeni kocky ju priniest do
% ciela do pozicie (40,40)

% toto riesenie obsahuje aj radar na hladanie kocky v def. okruhu, po
% najdeni kocky ju zoberie do ciela

%robot=[poziciaX poziciaY snimacLavo snimacPravo snimacVpred pohyb otocenie smer kocka prekazka cielx ciely offset_rand gain_rand]

% poziciaX - stlpec 1 az 40, poziciaY - riadok 1 az 40

% snimacLavo snimacPravo snimacVpred , 0-volne, 1-prekazka, 2-kocka,
% 3-iny robot

% pohyb , 0-stoji, 1-ide

% otocenie, 0-rovno, 1-doprava, 2-dolava

% smer, 1-hore, 2-dole, 3-doprava, 4-dolava

% kocka, 0-nema kocku,hlada ju, 1-nesie kocku na ciel (40,40), 2 - ide na
% definovany ciel

% prekazka, kde je prekazka 0-nie je, 1-hore, 2-dole, 3-doprava, 4-dolava,
% ak su zaporne hodnoty, prekazka je v cieli

% cielX - stlpec 1 az 40, cielY - riadok 1 az 40

% param1, param2 - parametre pre random hladanie

% hlavna funkcia
function [caszberu]=mainrobot1fun2(pocetkociek,pocetprekazok)

h1=figure;

% definovanie color mapy 1-pozadie, 2-prekazka, 3-robot, 4-robot s kockou,
% 5- kocka
colormaprobot=[1 1 1;0 0 0;0 1 0;1 0 0;0 0 1;1 1 0];
mapa=ones(42);
mapa(1,:)=2;
mapa(42,:)=2;
mapa(:,1)=2;
mapa(:,42)=2;


% definovanie prekazok
if pocetprekazok>0
mapa(2:5,8)=2;
mapa(6,8:10)=2;

if pocetprekazok>1
mapa(2:7,23)=2;
mapa(8,19:23)=2;

if pocetprekazok>2
mapa(34:41,28)=2;
mapa(34,25:28)=2;

if pocetprekazok>3
mapa(34,10:12)=2;
mapa(35:41,10)=2;

if pocetprekazok>4
mapa(20,32:41)=2;
mapa(18:22,32)=2;
end
end
end
end
end

stanicaX=40;
stanicaY=40;

pocetrobot=3;
dosahradaru=3;
maxcashladania=2000;

% definovanie parametrov robota
roboti(1)=struct('poziciaX',1,'poziciaY',1,'snimacLavo',1,'snimacPravo',0,'snimacVpred',1,'pohyb',0,'otocenie',0, ...
        'smer',1,'kocka',0,'prekazka',0,'cielX',40,'cielY',40,'param1',10,'param2',40,'pocitadlo',0,'maxkrok',0,'bludenie',0);
roboti(2)=struct('poziciaX',1,'poziciaY',40,'snimacLavo',1,'snimacPravo',0,'snimacVpred',1,'pohyb',0,'otocenie',0, ...
        'smer',1,'kocka',0,'prekazka',0,'cielX',40,'cielY',40,'param1',10,'param2',40,'pocitadlo',0,'maxkrok',0,'bludenie',0);
roboti(3)=struct('poziciaX',40,'poziciaY',1,'snimacLavo',1,'snimacPravo',0,'snimacVpred',1,'pohyb',0,'otocenie',0, ...
        'smer',1,'kocka',0,'prekazka',0,'cielX',40,'cielY',40,'param1',10,'param2',40,'pocitadlo',0,'maxkrok',0,'bludenie',0);

% zoznam
zindex=0;
zoznam(1)=struct('poziciaX',2,'poziciaY',2);

% mapovanie
global mapovanie
mapovanie(1:42,1:42)=2;
mapovanie(1,:)=1;
mapovanie(42,:)=1;
mapovanie(:,1)=1;
mapovanie(:,42)=1;
% zakreslenie robota
mapa(2,2)=3;

% parametre na nahodne hladanie
roboti(1).maxkrok=fix(40*rand);
roboti(2).maxkrok=fix(40*rand);
roboti(3).maxkrok=fix(40*rand);

% definovanie pozicii kociek
kockypos=[5 12;15 22;23 18;25 35;37 16;37 5;10 6;22 8;35 32;8 31;15 35;12 15;30 20;12 28;20 25;15 10;35 20;30 36;5 30;28 9];
if pocetkociek>20
    pocetkociek=20;
end
indx=randperm(pocetkociek);
for i=1:pocetkociek,
    mapa(kockypos(indx(i),1),kockypos(indx(i),2))=5;
end

% pociatocne vykreslenie mapy
colormap(colormaprobot);
hmapa=image(mapa);
k=0;
pocetuloh=0;
title(['ulozene kocky = ' num2str(pocetuloh)])

h2=figure;

% definovanie color mapy 1-pozadie, 2-prekazka, 3-robot, 4-robot s kockou,
% 5- kocka
colormaprobot=[1 1 0;0 0 0;0 1 0;1 0 0;0 0 1;1 1 0];
colormap(colormaprobot);
hmapa2=image(mapovanie);


% hlavny cyklus
while k<maxcashladania && pocetuloh~=pocetkociek;
    k=k+1;
    for rrob=1:pocetrobot,
       
        % vyber pixelov z mapy
        hp=mapa(roboti(rrob).poziciaY,roboti(rrob).poziciaX+1);
        dp=mapa(roboti(rrob).poziciaY+2,roboti(rrob).poziciaX+1);
        pp=mapa(roboti(rrob).poziciaY+1,roboti(rrob).poziciaX+2);
        vp=mapa(roboti(rrob).poziciaY+1,roboti(rrob).poziciaX);
        
        % nastavenie snimacov robota
        [vs,ps,hs]=nastavsnimace(roboti(rrob),hp,dp,pp,vp);
             
        roboti(rrob).snimacLavo=vs;
        roboti(rrob).snimacPravo=ps;
        roboti(rrob).snimacVpred=hs;
        
        % chod do stanice
        if roboti(rrob).kocka==1
            %novysmer=choddostanice(roboti(rrob));
            roboti(rrob).cielX=40;
            roboti(rrob).cielY=40;
            [novysmer,novaprekazka]=chodnaciel(roboti(rrob));
            roboti(rrob).prekazka=novaprekazka;
            if novysmer>-1
                roboti(rrob).otocenie=novysmer;
                roboti(rrob).pohyb=1;
            else
                roboti(rrob).pohyb=0;
            end
            
        % chod na ciel    
        elseif roboti(rrob).kocka==2
            [novysmer,novaprekazka]=chodnaciel(roboti(rrob));
            roboti(rrob).prekazka=novaprekazka;
            if novysmer>-1
                roboti(rrob).otocenie=novysmer;
                roboti(rrob).pohyb=1;
            else
                % ak je prekazka v cieli kocka, zober ju
                if novaprekazka<0
                    roboti(rrob).otocenie=0;
                    roboti(rrob).prekazka=0;
                    roboti(rrob).smer=abs(novaprekazka);
                else

                    roboti(rrob).pohyb=0;
                    if roboti(rrob).poziciaX==roboti(rrob).cielX && roboti(rrob).poziciaY==roboti(rrob).cielY
                        roboti(rrob).kocka=0;

                    end
                end
            end    
            
            % nahodne hladanie
        else
            [novysmer,kk,nahoda]=nahodnehladanie(roboti(rrob));
            % nastavenie smeru
            if novysmer>-1
                roboti(rrob).otocenie=novysmer;
                roboti(rrob).pohyb=1;
            else
                roboti(rrob).pohyb=0;
            end
            roboti(rrob).pocitadlo=kk;
            roboti(rrob).maxkrok=nahoda;           
        end
        
        % nastav novu poziciu robota
        stareX=roboti(rrob).poziciaX;
        stareY=roboti(rrob).poziciaY;
        mapa(stareY+1,stareX+1)=1;

        noveX=stareX;
        noveY=stareY;
        
        % ak je robot v pohybe nastav smer cesty
        if roboti(rrob).pohyb==1
            [posX,posY,otoc]=nastavsmercesty(roboti(rrob));
            noveX=posX;
            noveY=posY;
            if otoc>0
                roboti(rrob).smer=otoc;
            end

        end
        
        
        jetam=0;
        [najdenepozkocky]=najdikocku(roboti(rrob),mapa,dosahradaru);
        if isempty(najdenepozkocky)==0
            for lol=1:zindex
                if((najdenepozkocky(1,2) == zoznam(lol).poziciaX))
                    if (najdenepozkocky(1,1) == zoznam(lol).poziciaY)
                        jetam=1;
                    end
                end
            end
            if(jetam==0)
                zindex=zindex+1;
                zoznam(zindex).poziciaX=najdenepozkocky(1,2);
                zoznam(zindex).poziciaY=najdenepozkocky(1,1);
            end
        end
        % ak nesie kocku
        if roboti(rrob).kocka==1
        
            % ak priniesol kocku do ciela
            if noveX==40 && noveY==40
                n=0;
                roboti(rrob).kocka=0;
                if(zindex>0)
                    roboti(rrob).cielX=zoznam(zindex).poziciaX;
                    roboti(rrob).cielY=zoznam(zindex).poziciaY;
                    roboti(rrob).kocka=2;
                    zindex=zindex-1;
                else 
                    [row,col] = find(mapovanie==2);
                    if isempty(row)==0
                        mapai=1;
                        while(mapa(row(mapai),col(mapai))==2)
                            mapai=mapai+1;
                        end
                        if (mapa(row(mapai),col(mapai))~=2)
                            roboti(rrob).cielX=col(mapai)-1;
                            roboti(rrob).cielY=row(mapai)-1;
                            roboti(rrob).kocka=2;
                        end
                    end
                    
                end
                    pocetuloh=pocetuloh+1;
                figure(h1)
                title(['ulozene kocky = ' num2str(pocetuloh) ' cas [s] = ' num2str(k)])
            end
        end
        
        % ak nasiel kocku, nastav stav zober kocku
        if mapa(noveY+1,noveX+1)==5
            roboti(rrob).kocka=1;
            roboti(rrob).smer=2;
            roboti(rrob).otocenie=0;
            figure(h1)
            title(['ulozene kocky = ' num2str(pocetuloh) ' cas [s] = ' num2str(k)])
        end

        % ak nema kocku prehlada priestor ultrazvukom
        if roboti(rrob).kocka==0
            if(zindex>0)
                    roboti(rrob).cielX=zoznam(zindex).poziciaX;
                    roboti(rrob).cielY=zoznam(zindex).poziciaY;
                    roboti(rrob).kocka=2;
                    zindex=zindex-1;
            else
                [row,col] = find(mapovanie==2);
                if isempty(row)==0
                    mapai=1;
                    while(mapa(row(mapai),col(mapai))==2)
                        mapai=mapai+1;
                    end
                    if (mapa(row(mapai),col(mapai))~=2)
                        roboti(rrob).cielX=col(mapai)-1;
                        roboti(rrob).cielY=row(mapai)-1;
                        roboti(rrob).kocka=2;
                    end
                end
 
            end
            
            start=1;
        end
        
        % zakreslenie novej pozicie robota
        if roboti(rrob).kocka==1 
            mapa(noveY+1,noveX+1)=4;
        else
            mapa(noveY+1,noveX+1)=3;
        end
                
        % prekreslenie mapy 
        figure(h1)
        set(hmapa,'CData',mapa)
        roboti(rrob).poziciaX=noveX;
        roboti(rrob).poziciaY=noveY;
        figure(h2)
        set(hmapa2,'CData',mapovanie)
        roboti(rrob).poziciaX=noveX;
        roboti(rrob).poziciaY=noveY;


 
        pause(0.002)
%         rrob
%         roboti(rrob).cielX
%         roboti(rrob).cielY
        zindex
    end
end
caszberu=k;
end








% funkcia pre riadenie robota do ciela
% novysmer , 0-rovno, 1-vpravo, 2-vlavo, -1 - bez zmeny
% prekazka - 0-nie je, 1-hore, 2-dole, 3-doprava, 4-dolava,
% ak su zaporne hodnoty, prekazka je v cieli
function [novysmer,prekazka]=chodnaciel(robot)
    
    % suradnice ciela robota
    xciel=robot.cielX;
    yciel=robot.cielY;
    
    % kde sa nachadza ciel od aktualnej pozicie robota, vlavo, vpravo, hore
    % dole
    if (xciel-robot.poziciaX)>0
        idevpravo=1;
    else
        idevpravo=0;
    end
    if (xciel-robot.poziciaX)<0
        idevlavo=1;
    else
        idevlavo=0;
    end
    if (yciel-robot.poziciaY)>0
        idedole=1;
    else
        idedole=0;
    end
    if (yciel-robot.poziciaY)<0
        idehore=1;
    else
        idehore=0;
    end

    novysmer=-1;
    prekazka=robot.prekazka;
    % ak nenarazil na prekazku
    if prekazka==0
        
        % ma ist smerom dole
        if idedole==1
           if robot.smer==2 && robot.snimacVpred==0
                novysmer=0;
           elseif robot.smer==3 && robot.snimacPravo==0    %ide vpravo, vpravo volno, otoc dole 
                novysmer=1;
           elseif robot.smer==4 && robot.snimacLavo==0
                novysmer=2;
           elseif robot.smer==1 
                if idevpravo==1 && robot.snimacPravo==0
                    novysmer=1;
                elseif idevlavo==1 && robot.snimacLavo==0
                    novysmer=2;
                end
           end
        end
    
    if novysmer==-1
        % ma ist smerom hore
        if idehore==1
           if robot.smer==1 && robot.snimacVpred==0
                novysmer=0;
           elseif robot.smer==3 && robot.snimacLavo==0    %ide vpravo, vpravo volno, otoc dole 
                novysmer=2;
           elseif robot.smer==4 && robot.snimacPravo==0
                novysmer=1;
           elseif robot.smer==2 
                if idevpravo==1 && robot.snimacLavo==0
                    novysmer=2;
                elseif idevlavo==1 && robot.snimacPravo==0
                    novysmer=1;
                end
           end            
        end
    end
                    
    if novysmer==-1
        % ma ist smerom vpravo
        if idevpravo==1
           if robot.smer==1 && robot.snimacPravo==0
                novysmer=1;
           elseif robot.smer==3 && robot.snimacVpred==0    %ide vpravo, vpravo volno, otoc dole 
                novysmer=0;
           elseif robot.smer==2 && robot.snimacLavo==0
                novysmer=2;
           elseif robot.smer==4 
                if idehore==1 && robot.snimacPravo==0
                    novysmer=1;
                elseif idedole==1 && robot.snimacLavo==0
                    novysmer=2;
                end
           end            
        end
    end
                
    if novysmer==-1
        % ma ist smerom vlavo
        if idevlavo==1
           if robot.smer==1 && robot.snimacLavo==0
                novysmer=2;
           elseif robot.smer==4 && robot.snimacVpred==0    %ide vpravo, vpravo volno, otoc dole 
                novysmer=0;
           elseif robot.smer==2 && robot.snimacPravo==0
                novysmer=1;
           elseif robot.smer==3 
                if idehore==1 && robot.snimacLavo==0
                    novysmer=2;
                elseif idedole==1 && robot.snimacPravo==0
                    novysmer=1;
                end
           end            
        end
    end
    
    % nie je mozny ziadny smer
    if novysmer==-1
        % ak nie je v cieli, tak nastav prekazku
        if xciel~=robot.poziciaX
            if idevpravo==1 && (xciel-robot.poziciaX)==1
                prekazka=-3;
            elseif idevpravo==1
                prekazka=3;
            elseif idevlavo==1 && (robot.poziciaX-xciel)==1
                prekazka=-4;                
            elseif idevlavo==1
                prekazka=4;
            end  
        elseif yciel~=robot.poziciaY
            if idehore==1 && (robot.poziciaY-yciel)==1
                prekazka=-1; 
            elseif idehore==1
                prekazka=1; 
            elseif idedole==1 && (yciel-robot.poziciaY)==1
                prekazka=-2;
            elseif idedole==1
                prekazka=2;
            end                       
        end        
    end
    
    % ak je prekazka, potom jej obchadzanie
    else
        
        % prekazka vpravo
        if prekazka==3 && yciel<21
           if robot.smer==3 && robot.snimacVpred~=0 && robot.snimacPravo~=0 && robot.snimacLavo==0 % ak ide doprava,prekazka vpredu a vpravo, vlavo volno otoc dolava hore
                novysmer=2;
           elseif robot.smer==3 && robot.snimacVpred~=0 && robot.snimacPravo==0 % ak ide doprava,prekazka vpredu , vpravo volno otoc doprava hole
                novysmer=1;                
           elseif robot.smer==2 && robot.snimacLavo~=0 && robot.snimacVpred==0 % ak ide dole,prekazka vlavo, vpred volno pokracuj rovno
                novysmer=0; 
           elseif robot.smer==2 && robot.snimacLavo~=0 && robot.snimacVpred~=0 % ak ide dole,prekazka vlavo a rovno, otoc vpravo
                novysmer=1;                 
           elseif robot.smer==2 && robot.snimacLavo==0 && robot.snimacVpred==0  % ak ide dole,prekazka vlavo a rovno nieje, otoc dolava
                novysmer=2;
           elseif robot.smer==2 && robot.snimacLavo==0 && robot.snimacVpred~=0 && robot.snimacPravo==0 % ak ide dole,prekazka rovno, vlavo a vpravo je volno, otoc doprava
                novysmer=1;               
           elseif robot.smer==4 && robot.snimacLavo~=0 && robot.snimacVpred==0 % ak ide dolava,prekazka vlavo, vpred je volno, chod rovno
                novysmer=0;
           elseif robot.smer==4 && robot.snimacLavo==0 % ak ide dolava, vlavo je volno, chod dolava
                novysmer=2;         
           elseif robot.smer==1 % ak ide dole, toc dolava
                novysmer=2;
           elseif robot.smer==3 && robot.snimacVpred==0 && robot.poziciaX<xciel % ak ide doprava, rovno je volno, este nie je v cieli, chod rovno a vypni obchadzanie prekazky  
                novysmer=0;
                prekazka=0;
           end               
           
        elseif prekazka==3 && yciel>20
           if robot.smer==3 && robot.snimacVpred~=0 && robot.snimacLavo~=0 && robot.snimacPravo==0 % ak ide doprava,prekazka vpredu a vlavo, vpravo volno otoc doprava dole
                novysmer=1;
           elseif robot.smer==3 && robot.snimacVpred~=0 && robot.snimacLavo==0 % ak ide doprava,prekazka vpredu , vlavo volno otoc dolava hole
                novysmer=2;                
           elseif robot.smer==1 && robot.snimacPravo~=0 && robot.snimacVpred==0 % ak ide hore,prekazka vpravo, vpred volno pokracuj rovno
                novysmer=0; 
           elseif robot.smer==1 && robot.snimacPravo~=0 && robot.snimacVpred~=0 % ak ide hore,prekazka vpravo a rovno, otoc vlavo
                novysmer=2;                 
           elseif robot.smer==1 && robot.snimacPravo==0 && robot.snimacVpred==0  % ak ide hore,prekazka vpravo a rovno nieje, otoc doprava
                novysmer=1;
           elseif robot.smer==1 && robot.snimacPravo==0 && robot.snimacVpred~=0 && robot.snimacLavo==0 % ak ide hore,prekazka rovno, vlavo a vpravo je volno, otoc dolava
                novysmer=2;               
           elseif robot.smer==4 && robot.snimacPravo~=0 && robot.snimacVpred==0 % ak ide dolava,prekazka vpravo, vpred je volno, chod rovno
                novysmer=0;
           elseif robot.smer==4 && robot.snimacPravo==0 % ak ide dolava, vpravo je volno, chod doprava
                novysmer=1;         
           elseif robot.smer==2 % ak ide dole, toc dolava
                novysmer=1;
           elseif robot.smer==3 && robot.snimacVpred==0 && robot.poziciaX<xciel % ak ide doprava, rovno je volno, este nie je v cieli, chod rovno a vypni obchadzanie prekazky  
                novysmer=0;
                prekazka=0;
           end               
        end
        
        % prekazka vlavo
        if prekazka==4 && yciel>20
           if robot.smer==4 && robot.snimacVpred~=0 && robot.snimacPravo~=0 && robot.snimacLavo==0 % ak ide doprava,prekazka vpredu a vpravo, vlavo volno otoc dolava hore
                novysmer=2;
           elseif robot.smer==4 && robot.snimacVpred~=0 && robot.snimacPravo==0 % ak ide dolava,prekazka vpredu , vpravo volno otoc doprava hole
                novysmer=1;                
           elseif robot.smer==1 && robot.snimacLavo~=0 && robot.snimacVpred==0 % ak ide dole,prekazka vlavo, vpred volno pokracuj rovno
                novysmer=0; 
           elseif robot.smer==1 && robot.snimacLavo~=0 && robot.snimacVpred~=0 % ak ide dole,prekazka vlavo a rovno, otoc vpravo
                novysmer=1;                 
           elseif robot.smer==1 && robot.snimacLavo==0 && robot.snimacVpred==0  % ak ide dole,prekazka vlavo a rovno nieje, otoc dolava
                novysmer=2;
           elseif robot.smer==1 && robot.snimacLavo==0 && robot.snimacVpred~=0 && robot.snimacPravo==0 % ak ide dole,prekazka rovno, vlavo a vpravo je volno, otoc doprava
                novysmer=1;               
           elseif robot.smer==3 && robot.snimacLavo~=0 && robot.snimacVpred==0 % ak ide doprava,prekazka vlavo, vpred je volno, chod rovno
                novysmer=0;
           elseif robot.smer==3 && robot.snimacLavo==0 % ak ide doprava, vlavo je volno, chod dolava
                novysmer=2;
           elseif robot.smer==3 && robot.snimacLavo~=0 && robot.snimacVpred~=0 % ak ide dolava,prekazka vlavo, vpred je volno, chod rovno
                novysmer=1;
           elseif robot.smer==2 && robot.snimacLavo~=0 && robot.snimacVpred==0 && abs(robot.poziciaY-yciel)<4 % ak ide dole, toc doprava
                novysmer=0;               
           elseif robot.smer==2 && robot.snimacLavo~=0 % ak ide dole, toc doprava
                novysmer=1;
           elseif robot.smer==2 % ak ide dole, toc dolava
                novysmer=2;
           elseif robot.smer==4 && robot.snimacVpred==0 && robot.poziciaX>xciel % ak ide doprava, rovno je volno, este nie je v cieli, chod rovno a vypni obchadzanie prekazky  
                novysmer=0;
                prekazka=0;
           end               
           
        elseif prekazka==4 && yciel<21
           if robot.smer==4 && robot.snimacVpred~=0 && robot.snimacLavo~=0 && robot.snimacPravo==0 % ak ide doprava,prekazka vpredu a vlavo, vpravo volno otoc doprava dole
                novysmer=1;
           elseif robot.smer==4 && robot.snimacVpred~=0 && robot.snimacLavo==0 % ak ide doprava,prekazka vpredu , vlavo volno otoc dolava hole
                novysmer=2;                
           elseif robot.smer==2 && robot.snimacPravo~=0 && robot.snimacVpred==0 % ak ide hore,prekazka vpravo, vpred volno pokracuj rovno
                novysmer=0; 
           elseif robot.smer==2 && robot.snimacPravo~=0 && robot.snimacVpred~=0 % ak ide hore,prekazka vpravo a rovno, otoc vlavo
                novysmer=2;                 
           elseif robot.smer==2 && robot.snimacPravo==0 && robot.snimacVpred==0  % ak ide hore,prekazka vpravo a rovno nieje, otoc doprava
                novysmer=1;
           elseif robot.smer==2 && robot.snimacPravo==0 && robot.snimacVpred~=0 && robot.snimacLavo==0 % ak ide hore,prekazka rovno, vlavo a vpravo je volno, otoc dolava
                novysmer=2;               
           elseif robot.smer==3 && robot.snimacPravo~=0 && robot.snimacVpred==0 % ak ide dolava,prekazka vpravo, vpred je volno, chod rovno
                novysmer=0;
           elseif robot.smer==3 && robot.snimacPravo==0 % ak ide dolava, vpravo je volno, chod doprava
                novysmer=1;         
           elseif robot.smer==1 % ak ide dole, toc dolava
                novysmer=1;
           elseif robot.smer==4 && robot.snimacVpred==0 && robot.poziciaX>xciel % ak ide doprava, rovno je volno, este nie je v cieli, chod rovno a vypni obchadzanie prekazky  
                novysmer=0;
                prekazka=0;
           end               
           
        end

        % prekazka hore
        if prekazka==1      %&& xciel>20
           if robot.smer==1 && robot.snimacVpred~=0 && robot.snimacLavo~=0 && robot.snimacPravo==0 % ak ide doprava,prekazka vpredu a vpravo, vlavo volno otoc dolava hore
                novysmer=1;
           elseif robot.smer==1 && robot.snimacVpred~=0 && robot.snimacLavo==0 % ak ide doprava,prekazka vpredu , vpravo volno otoc doprava hole
                novysmer=2;                
           elseif robot.smer==4 && robot.snimacPravo~=0 && robot.snimacVpred==0 % ak ide dole,prekazka vlavo, vpred volno pokracuj rovno
                novysmer=0; 
           elseif robot.smer==4 && robot.snimacPravo~=0 && robot.snimacVpred~=0 % ak ide dole,prekazka vlavo a rovno, otoc vpravo
                novysmer=2;                 
           elseif robot.smer==4 && robot.snimacPravo==0 && robot.snimacVpred==0  % ak ide dole,prekazka vlavo a rovno nieje, otoc dolava
                novysmer=1;
           elseif robot.smer==4 && robot.snimacLavo==0 && robot.snimacVpred~=0 && robot.snimacPravo==0 % ak ide dole,prekazka rovno, vlavo a vpravo je volno, otoc doprava
                novysmer=2;               
           elseif robot.smer==2 && robot.snimacPravo~=0 && robot.snimacVpred==0 % ak ide dolava,prekazka vlavo, vpred je volno, chod rovno
                novysmer=0;
           elseif robot.smer==2 && robot.snimacPravo==0 % ak ide dolava, vlavo je volno, chod dolava
                novysmer=1;         
           elseif robot.smer==3 % ak ide dole, toc dolava
                novysmer=1;
           elseif robot.smer==1 && robot.snimacVpred==0 && robot.poziciaY>yciel % ak ide doprava, rovno je volno, este nie je v cieli, chod rovno a vypni obchadzanie prekazky  
                novysmer=0;
                prekazka=0;
           end               
                     
        end

        % prekazka dole
        if prekazka==2  %&& xciel>20
           if robot.smer==2 && robot.snimacVpred~=0 && robot.snimacPravo~=0 && robot.snimacLavo==0 % ak ide doprava,prekazka vpredu a vpravo, vlavo volno otoc dolava hore
                novysmer=2;
           elseif robot.smer==2 && robot.snimacVpred~=0 && robot.snimacPravo==0 % ak ide doprava,prekazka vpredu , vpravo volno otoc doprava hole
                novysmer=1;                
           elseif robot.smer==4 && robot.snimacLavo~=0 && robot.snimacVpred==0 % ak ide dole,prekazka vlavo, vpred volno pokracuj rovno
                novysmer=0; 
           elseif robot.smer==4 && robot.snimacLavo~=0 && robot.snimacVpred~=0 % ak ide dole,prekazka vlavo a rovno, otoc vpravo
                novysmer=1;                 
           elseif robot.smer==4 && robot.snimacLavo==0 && robot.snimacVpred==0  % ak ide dole,prekazka vlavo a rovno nieje, otoc dolava
                novysmer=2;
           elseif robot.smer==4 && robot.snimacLavo==0 && robot.snimacVpred~=0 && robot.snimacPravo==0 % ak ide dole,prekazka rovno, vlavo a vpravo je volno, otoc doprava
                novysmer=1;               
           elseif robot.smer==1 && robot.snimacLavo~=0 && robot.snimacVpred==0 % ak ide dolava,prekazka vlavo, vpred je volno, chod rovno
                novysmer=0;
           elseif robot.smer==1 && robot.snimacLavo==0 % ak ide dolava, vlavo je volno, chod dolava
                novysmer=2;         
           elseif robot.smer==3 % ak ide dole, toc dolava
                novysmer=2;
           elseif robot.smer==2 && robot.snimacVpred==0 && robot.poziciaY<yciel % ak ide doprava, rovno je volno, este nie je v cieli, chod rovno a vypni obchadzanie prekazky  
                novysmer=0;
                prekazka=0;
           end               
                     
        end        
        
        
    end
               
end


% funkcia na nahodne prehladavanie
% novysmer , 0-rovno, 1-vpravo, 2-vlavo, -1 - bez zmeny
% kki, kko - pocitadlo
% nahodai, nahodao - kedy ma byt vykonana zmena smeru 
function [novysmer,kko,nahodao]=nahodnehladanie(robot)
        if robot.snimacPravo==2  % ak je vpravo kocka, chod doprava
           novysmer=1;
        elseif robot.snimacLavo==2  % ak je vlavo kocka, chod dolava
           novysmer=2; 
        elseif robot.snimacVpred==0 || robot.snimacVpred==2 % ak je rovno kocka alebo volno chod rovno
           novysmer=0;
        elseif robot.snimacVpred~=0 && robot.snimacPravo==0 && robot.snimacLavo==0 % ak je rovno prekazka, vpravo aj vlavo volno, vyber si vlavo alebo vpravo
           if rand<0.4
               novysmer=2;
           else
               novysmer=1;
           end
        elseif robot.snimacVpred~=0 && robot.snimacPravo==0   % ak je rovno prekazka, vpravo  volno, chod vpravo
           novysmer=1;
        elseif robot.snimacVpred~=0 && robot.snimacLavo==0
           novysmer=2;
        else
            novysmer=-1;
        end
        
        % nahodna zmena smeru
        if robot.pocitadlo==robot.maxkrok 
           % ak ide rovno, zmen smer 
           if novysmer==0 && robot.snimacVpred~=2
               % ak je vlavo volno, chod vlavo
               if robot.snimacLavo==0
                  novysmer=2;
               elseif robot.snimacPravo==0  % ak je vpravo volno, chod vpravo
                  novysmer=1;
               end
           end
           % nahodne generovanie casu na zmenu smeru
           robot.maxkrok=fix(robot.param2*rand+robot.param1);
           kko=0;
        else
            kko=robot.pocitadlo+1;
        end
        nahodao=robot.maxkrok;     
end

% funkcia na nastavenie smeru cesty, podla toho ktorym smerom je otoceny
% vypocita poziciu robota a ktorym smerom sa ma otocit
function [posX,posY,otoc]=nastavsmercesty(robot)
    stareX=robot.poziciaX;
    stareY=robot.poziciaY;
    posX=robot.poziciaX;
    posY=robot.poziciaY;
    otoc=0;
    % nastavenie smeru cesty
    if robot.pohyb==1
        if robot.otocenie==0 && robot.smer==1 % hore
            posX=stareX;
            posY=stareY-1;
        elseif robot.otocenie==0 && robot.smer==2 % dole
            posX=stareX;
            posY=stareY+1;
        elseif robot.otocenie==0 && robot.smer==3 % vpravo
            posX=stareX+1;
            posY=stareY;
        elseif robot.otocenie==0 && robot.smer==4 % vlavo
            posX=stareX-1;
            posY=stareY;
            
        elseif robot.otocenie==1 && robot.smer==1 % otocenie vpravo
            posX=stareX+1;
            posY=stareY;
            otoc=3;
         elseif robot.otocenie==1 && robot.smer==3 % otocenie dole
            posX=stareX;
            posY=stareY+1;
            otoc=2;
         elseif robot.otocenie==1 && robot.smer==2 % otocenie vlavo
            posX=stareX-1;
            posY=stareY;
            otoc=4;
         elseif robot.otocenie==1 && robot.smer==4 % otocenie hore
            posX=stareX;
            posY=stareY-1;
            otoc=1;
            
        elseif robot.otocenie==2 && robot.smer==1 % otocenie vlavo
            posX=stareX-1;
            posY=stareY;
            otoc=4;
         elseif robot.otocenie==2 && robot.smer==3 % otocenie hore
            posX=stareX;
            posY=stareY-1;
            otoc=1;
         elseif robot.otocenie==2 && robot.smer==2 % otocenie vpravo
            posX=stareX+1;
            posY=stareY;
            otoc=3;
         elseif robot.otocenie==2 && robot.smer==4 % otocenie dole
            posX=stareX;
            posY=stareY+1;
            otoc=2;
        end
    end
    if posY<1
        posY=1;
    end
    if posX<1
        posX=1;
    end    
    if posX>40
        posX=40;
    end    
    if posY>40
        posY=40;
    end 

end

% nastavenie stavu snimacov, podla pixelov v mape
function [vs,ps,hs]=nastavsnimace(robot,horepole,dolepole,vpravopole,vlavopole)
    
    % smer hore
    if robot.smer==1 
        if horepole==2
            hs=1;
        elseif horepole==5
            hs=2;  
        elseif horepole==3 || horepole==4
            hs=3;               
        else
            hs=0;            
        end
        if vlavopole==2
            vs=1;
        elseif vlavopole==5
            vs=2;
        elseif vlavopole==3 || vlavopole==4
            vs=3;                                                           
        else
            vs=0;                      
        end
        if vpravopole==2
            ps=1;
        elseif vpravopole==5
            ps=2;                                                 
        elseif vpravopole==3 || vpravopole==4
            ps=3;                                                           
        else
            ps=0;                      
        end
        
    end
    % smer dole
    if robot.smer==2
        if dolepole==2
            hs=1;
        elseif dolepole==5
            hs=2;
        elseif dolepole==3 || dolepole==4
            hs=3;                                                           
        else
            hs=0;            
        end
        if vpravopole==2
            vs=1;
        elseif vpravopole==5
            vs=2;    
        elseif vpravopole==3 || vpravopole==4
            vs=3;                                               
        else
            vs=0;                      
        end
        if vlavopole==2
            ps=1;
        elseif vlavopole==5
            ps=2;
        elseif vlavopole==3 || vlavopole==4
            ps=3;                                               
        else
            ps=0;                      
        end
        
    end
     % smer vpravo
    if robot.smer==3
        if vpravopole==2
            hs=1;
        elseif vpravopole==5
            hs=2;
        elseif vpravopole==3 || vpravopole==4
            hs=3;                                   
        else
            hs=0;            
        end
        if horepole==2
            vs=1;
        elseif horepole==5
            vs=2;
        elseif horepole==3 || horepole==4
            vs=3;                                                           
        else
            vs=0;                      
        end
        if dolepole==2
            ps=1;
        elseif dolepole==5
            ps=2;
        elseif dolepole==3 || dolepole==4
            ps=3;                                               
        else
            ps=0;                      
        end
        
    end
     % smer vlavo
    if robot.smer==4
        if vlavopole==2
            hs=1;
        elseif vlavopole==5
            hs=2;
        elseif vlavopole==3 || vlavopole==4
            hs=3;                       
        else
            hs=0;            
        end
        if dolepole==2
            vs=1;
        elseif dolepole==5
            vs=2;  
        elseif dolepole==3 || dolepole==4
            vs=3;                                   
        else
            vs=0;                      
        end
        if horepole==2
            ps=1;
        elseif horepole==5
            ps=2;
        elseif horepole==3 || horepole==4
            ps=3;                                               
        else
            ps=0;                      
        end
        
    end
 
end

% funkcia na prehladanie okolia robota radarom
% vrati pozicie kociek [Y X] - [riadok stlpec] v mape
function [novapozkocky]=najdikocku(robot,celamapa,dosahsenzora)
    global mapovanie
    % def. rozsahu senzora
    rmin=robot.poziciaY-dosahsenzora+1;
    rmax=robot.poziciaY+dosahsenzora+1;
    smin=robot.poziciaX-dosahsenzora+1;
    smax=robot.poziciaX+dosahsenzora+1;
    
    % ohranicenie mapy
    if rmin<2
        rmin=2;
    end
    if smin<1
        smin=1;
    end
    if rmax>41
        rmax=41;
    end
    if smax>41
        smax=41;
    end
    
    % ohranicenie prekazkov, radar cez prekaz nevidi
    ss=robot.poziciaX+1;
    for rr=rmin:robot.poziciaY+1,
        if celamapa(rr,ss)==2
            rmin=rr;
            break;
        end
    end
    rr=robot.poziciaY+1;
    for ss=smin:robot.poziciaX+1,
        if celamapa(rr,ss)==2
            smin=ss;
            break;
        end
    end
    ss=robot.poziciaX+1;
    for rr=robot.poziciaY+1:rmax,
        if celamapa(rr,ss)==2
            rmax=rr;
            break;
        end
    end
    rr=robot.poziciaY+1;
    for ss=robot.poziciaX+1:smax,
        if celamapa(rr,ss)==2
            smax=ss;
            break;
        end
    end    
    novapozkocky=[];
    
    % hladanie kocky v ohranicenom priestore
    for rr=rmin:rmax,
        for ss=smin:smax,
            if celamapa(rr,ss)==5
                novapozkocky=[novapozkocky;rr-1 ss-1];
            end
            mapovanie(rr,ss)=1;
        end
    end
            
end
