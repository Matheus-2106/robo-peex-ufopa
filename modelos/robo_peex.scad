$fa = 1;
$fs = 0.04;

// Fator de escala
escala = 1;

// Cores
cor_azul    = "#5DB8DB";
cor_preto   = "#1E2A3B";
cor_branco  = "#FFFFFF";

// Texto
tam_texto_x = 2;
texto_x     = "UFOPA";
tam_texto_y = 1;
texto_y     = "CULTURA MAKER";
tam_texto_z = 2;
texto_z     = "PEEx";

// Medidas da base
comp_base   = 20;
larg_base   = comp_base;
alt_base    = 5;

// Medidas do corpo
comp_corpo  = 7;
larg_corpo  = comp_corpo;
alt_corpo   = 9;

// Medidas do pescoço
alt_pesc    = 3;
dia_pesc    = 2;

// Medidas da cabeça
comp_cab    = 9;
larg_cab    = comp_cab*1.1;
alt_cab     = comp_cab*0.7;

// Medidas do braço
num_sec     = 6;
comp_braco  = 10;
diam_braco  = 2;
ang_braco_dir = [45,0,-45];
ang_antebraco_dir = [30,0,0];
ang_braco_esq = [30,0,0];
ang_antebraco_esq = [-45,0,-45];   

// Medidas da articulação do braço
diam_art   = diam_braco;

// Medidas da mão
comp_mao    = 2;
diam_mao    = diam_braco;

// Medidas do dedo
num_dedos   = 3;
comp_dedo   = 1;
diam_dedo   = 0.3;

// Medidas da antena
comp_antena = 5;
diam_antena = 0.4;
raio_ponta  = 2 * diam_antena;

// Medidas do olho
diam_olho   = 2;

// Medidas da boca
diam_boca   = 3;

// Medidas da orelha
diam_orelha = comp_cab / 3;


module base(_comp_base, _larg_base, _alt_base) {
    color(cor_preto)
        minkowski() {
            cube([_comp_base, _larg_base, _alt_base], center=true);
            sphere(r=0.25);
        }
    
    // Texto ao longo do eixo x
    rotate([90,0,90])
        espelha_texto(_comp_base)
            texto(texto_x, cor_branco, tam_texto_x);
        
    // Texto ao longo do eixo y
    rotate([90,0,0])
        espelha_texto(_larg_base)
            texto(texto_y, cor_branco, tam_texto_y);
        
    // Texto ao longo do eixo z
    translate([_comp_base/4,0,0])
        rotate([0,0,90])
            espelha_texto(_alt_base)
                texto(texto_z, cor_branco, tam_texto_z);
    
    /*translate([0,0,_alt_base/2])
        color(cor_branco)
            square(size=_comp_base, center=true);*/
}

module corpo(_comp_corpo, _larg_corpo, _alt_corpo) {
    color(cor_azul)
        minkowski() {
            cube([_comp_corpo, _larg_corpo, _alt_corpo], center=true);
            sphere(r=0.25);
        }
}

module pescoco(_alt_pesc, _dia_pesc) {
    color(cor_azul)
        cylinder(h=_alt_pesc, d=_dia_pesc, center=true);
}

module cabeca(_comp_cab, _larg_cab, _alt_cab) {
    color(cor_azul)
        minkowski() {
            cube([_comp_cab, _larg_cab, _alt_cab], center=true);
            sphere(r=0.25); 
        }
    
    translate([-2,2,_alt_cab/2 + comp_antena/2])
        antena(comp_antena, diam_antena, raio_ponta);
    
    color(cor_preto) {
        translate([_comp_cab/2,0,-_alt_cab/4])
            face();
        
        orelha(diam_orelha);
    }
}

module braco_completo(_ang_braco, _ang_antebraco) {
    rotate(_ang_braco) {
        braco_articulado();
        translate([0,comp_braco/2,0])
            rotate(_ang_antebraco) {
            braco_articulado();
        translate([0,comp_braco/2 + comp_mao/2,0])
            color(cor_preto)
                mao(comp_mao, diam_mao);
            }
        }
}

module braco_articulado() {
    translate([0,comp_braco/4,0])
        braco(comp_braco, diam_braco, num_sec);
    articulacao_braco(diam_art);
}

module braco(_comp_braco, _diam_braco, _num_sec) {
    step = (_comp_braco/2) / _num_sec;
    rotate([90,0,0])
        translate([0,0,-comp_braco/4])
            for (i = [1:step:_comp_braco/2 * 0.9]) {
                translate([0,0,i])
                color(cor_preto)
                    cylinder(h=0.1, d=_diam_braco * 1.05, center=true);
            }
    
    rotate([90,0,0])
        color(cor_azul)
            cylinder(h=_comp_braco/2, d=_diam_braco, center=true);
}

module articulacao_braco(_diam_art) {
    color(cor_preto)
        sphere(d=_diam_art);
}

module mao(_comp_mao, _diam_mao) {
    /* Os dedos estão dispostos na mão em uma circunferência */
    num_dedos   = num_dedos;
    raio        = 0.7 * _diam_mao/2;
    step = 360 / num_dedos;
    
    rotate([90,0,0])
        cylinder(h=_comp_mao, d=_diam_mao, center=true);
    for (i = [0:step:359]) {
        angle = i;
        dx = raio * cos(angle);
        dz = raio * sin(angle);
        translate([dx,_comp_mao/2 + comp_dedo/2,dz])
            dedo(comp_dedo, diam_dedo);
    }
}

module dedo(_comp_dedo, _diam_dedo) {
    rotate([90,0,0])
        cylinder(h=_comp_dedo, d=_diam_dedo, center=true);
}

module antena(_comp_antena, _diam_antena, _raio_ponta) {
    color(cor_preto)
        cylinder(h=_comp_antena, d=_diam_antena, center=true);
    translate([0,0,_comp_antena/2])
        color(cor_azul)
            sphere(r=_raio_ponta);
}

module face() {
    for (i = [-1:2:1]) {
        translate([0,i * larg_cab/3,alt_cab/3])
            olho(diam_olho);
    }
    
    boca(diam_boca);
}

module olho(_diam_olho) {
    rotate([0,90,0])
        cylinder(h=1, d=_diam_olho, center=true);
}

module boca(_diam_boca) {
    scale([1,1,0.4])
        rotate([0,90,0])
            cylinder(h=1, d=_diam_boca, center=true);
}

module orelha(_diam_orelha) {
    rotate([90,0,0])
        difference() {
            cylinder(h=larg_cab * 1.1, d=_diam_orelha, center=true);
            cylinder(h=larg_cab * 1.2, d=_diam_orelha * 0.9, center=true);
        }
}

module texto(_texto, _cor, _tam_texto) {
    color(_cor)
        linear_extrude(1, center=true)
            text(_texto, size=_tam_texto, halign="center", valign="center");
}

module espelha_texto(_distancia) {
    vetor_espelhamento = [0,0,1];
    
    translate([0,0,_distancia/2])
        children();
    translate([0,0,-_distancia/2])
        rotate([0,180,0])
        mirror(vetor_espelhamento)
            children();
}

module robo() {
    // Base
    base(comp_base, larg_base, alt_base);
    // Corpo
    translate([-comp_corpo/2,0,(alt_corpo/2 + alt_base/2)])
        corpo(comp_corpo, larg_corpo, alt_corpo);
    // Pescoço
    translate([-comp_corpo/2,0,(alt_base/2 + alt_corpo + alt_pesc/2)])
        pescoco(alt_pesc, dia_pesc);
    // Cabeça
    translate([-comp_corpo/2,0,(alt_base/2 + alt_corpo + alt_pesc + alt_cab/2)])
        cabeca(comp_cab, larg_cab, alt_cab);
    // Braços
    translate([-comp_corpo/2,larg_corpo/2,(alt_base/2 + 4*alt_corpo/5)])
        braco_completo(ang_braco_dir, ang_antebraco_dir);
    translate([-comp_corpo/2,-larg_corpo/2,(alt_base/2 + 4*alt_corpo/5)])
        rotate([180,0,0])
            braco_completo(ang_braco_esq, ang_antebraco_esq);
}

scale(escala)
    robo();
//base(comp_base, larg_base, alt_base);
//corpo(comp_corpo, larg_corpo, alt_corpo);
//pescoco(alt_pesc, dia_pesc);
//cabeca(comp_cab, larg_cab, alt_cab);
//braco(comp_braco, diam_braco, num_sec);
//mao(comp_mao, diam_mao);
//dedo(comp_dedo, diam_dedo);
//antena(comp_antena, diam_antena, raio_ponta);
//olho(diam_olho);
//face();
//boca(diam_boca);
//orelha(diam_orelha);
//articulacao_braco(diam_art);
//braco_completo(ang_braco_dir, ang_antebraco_dir);
//braco_articulado();
//texto(texto_x, cor_branco, tam_texto_x);
//espelha_texto(10) texto(texto_z, cor_azul, tam_texto_z);