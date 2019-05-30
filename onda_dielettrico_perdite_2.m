% Animazione che rappresenta un'onda incidente in un interfaccia tra due dielettrici diversi
% onda incidente normale, onda riflessa, onda totale nel mezzo 1 ; onda trasmessa nel mezzo 2

% dati del problema
E = 1;
f = 3*10^8;

eps1=4;
eps2=9;

sigma1 = 0;
sigma2 = 10;

mu1 = 1;
mu2 = 1;

% rinomino exp per comodita' 
e=exp(1);

% costanti nel vuoto
eps0=8.8541878128*10^(-12);
mu0=4*pi*10^(-7);

% parametri per gli slider ( si modificano i parametri mentre si plottano le onde )
fig = uifigure('Position', [1000 500 500 450]);
pn0 = uipanel(fig, 'Position',[0 0 200 100], 'Title','epsilon 1');
sld0 = uislider(pn0,'Position',[25 50 150 3]);
sld0.Limits = [1 20];
sld0.Value = eps1;

pnl = uipanel(fig, 'Position',[0 100 200 100], 'Title','mu 1');
sld1 = uislider(pnl,'Position',[25 50 150 3]);
sld1.Limits = [1 20];
sld1.Value = mu1;

pn2 = uipanel(fig, 'Position',[0 200 200 100], 'Title','sigma 1');
sld2 = uislider(pn2,'Position',[25 50 150 3]);
sld2.Limits = [0 10];
sld2.Value = sigma1;

pn3 = uipanel(fig, 'Position',[300 0 200 100], 'Title','epsilon 2');
sld3 = uislider(pn3,'Position',[25 50 150 3]);
sld3.Limits = [1 20];
sld3.Value = eps2;

pn4 = uipanel(fig, 'Position',[300 100 200 100], 'Title','mu 2');
sld4 = uislider(pn4,'Position',[25 50 150 3]);
sld4.Limits = [1 20];
sld4.Value = mu2;

pn5 = uipanel(fig, 'Position',[300 200 200 100], 'Title','sigma 2');
sld5 = uislider(pn5,'Position',[25 50 150 3]);
sld5.Limits = [0 10];
sld5.Value = sigma2;


pn6 = uipanel(fig, 'Position',[0 350 200 100], 'Title','frequenza (scala logaritmica)');
sld6 = uislider(pn6,'Position',[25 50 150 3]);
sld6.Limits = [1 13];
sld6.Value = log10(f);


pn7 = uipanel(fig, 'Position',[300 350 200 100], 'Title',"modulo del campo elettrico all'interfaccia");
sld7 = uislider(pn7,'Position',[25 50 150 3]);
sld7.Limits = [0.001 10];
sld7.Value = E;

% il passo è molto breve per distinguere in modo chiaro le varie onde per la grande velocità delll'onda
for t=0:0.00000000001:1
    
    % variabili collegate agli slider
    eps1 = sld0.Value;
    mu1 = sld1.Value;
    sigma1 = sld2.Value;

    eps2 = sld3.Value;
    mu2 = sld4.Value;
    sigma2 = sld5.Value;


    f = 10^sld6.Value;
    E = sld7.Value;

    % calcolo omega
    w=2*pi*f;

    % imposto i limiti del grafico spostando la linea più a destra proporzionalmente a quanto
    % il secondo mezzo sia conduttore
    if (sigma2 > w*eps0*eps1*10)
    delta = sqrt(2/(w*mu0*mu2*sigma2));
    X_len_pos=delta*10;
    else
    X_len_pos=1;
    end
    X_len_neg=-1;

    % dichiaro i valori delle x da considerare 
    % (la scala a destra e sinistra dell'interfaccia 
    % e' diversa cosi' da poter vedere meglio il 
    % decadimento dell' onda nel secondo dielettrico)
    x1=X_len_neg:0.001:0;
    x2=0:0.001:X_len_pos;

    % calcolo beta nel mezzo 1
    gamma1 = sqrt(1i.*w*mu0*mu1*(sigma1+1i.*w*eps0*eps1));

    % calcolo gamma nel mezzo 2
    gamma2 = sqrt(1i.*w*mu0*mu2*(sigma2+1i.*w*eps0*eps2));

    % calcolo rho e tau
    %eta1=sqrt(mu0/(eps0*eps1));
    eta1 = sqrt(1i.*w*mu0*mu1/(sigma1+1i.*w*eps0*eps1));
    eta2 = sqrt(1i.*w*mu0*mu1/(sigma2+1i.*w*eps0*eps2));
    rho = (eta2-eta1)/(eta2+eta1);
    tau = 1+rho;     

    % campo incidente
    Ei = E*(e.^(-gamma1.*x1));
    % campo riflesso
    Er = E*(rho.*e.^(gamma1.*x1));
    % campo totale nel mezzo 1
    Et = Ei+Er;

    % campo trasmesso
    Etr = E*(tau.*e.^(-gamma2.*x2));

    % plotto le diverse curve riportandole nel dominio del tempo
    % direttamente nel plot
    hold off
    plot(x1,real(Et*e.^(1i.*w.*t)),'-k')
    hold on
    plot(x1,real(Er*e.^(1i.*w.*t)),'-r')
    plot(x1,real(Ei*e.^(1i.*w.*t)),'-b')
    plot(x2,real(Etr*e.^(1i.*w.*t)),'-k')
    grid on

    % setto una linea verticale per far vedere la 
    % separazione tra i 2 dielettrici
    limx = 1.5*(abs(real(Ei(1))) + abs(real(Er(1))));
    line([0 0], [-limx limx], 'Color', [0 0 0])
    xlim([X_len_neg X_len_pos])
    ylim([-limx limx])
    xlabel(t)
    drawnow
  
end
