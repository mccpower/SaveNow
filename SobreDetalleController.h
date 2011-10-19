//
//  SobreDetalleController.h
//  EFM
//
//  Created by Noemi on 11/21/10.
//  Copyright 2010 Pynsoft All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFMAppDelegate.h"

@interface SobreDetalleController : UIViewController <UIActionSheetDelegate>{
	IBOutlet UILabel *lblTitulo;
	IBOutlet UILabel *lblPresupuesto;
	IBOutlet UILabel *lblGastado;
	IBOutlet UILabel *lblPorcentaje;
	IBOutlet UILabel *lblUltimoGasto;
	IBOutlet UILabel *lblFechaReset;
	IBOutlet UILabel *lblMonedaPresupuesto;
	IBOutlet UILabel *lblMonedaGastado;
	IBOutlet UILabel *lblMonedaUltimoGasto;
	
	IBOutlet UILabel *presupuestoDato;
	IBOutlet UILabel *gastadoDato;
	IBOutlet UILabel *porcentajeDato;
	IBOutlet UILabel *ultimoGastoDato;
	IBOutlet UILabel *fechaResetDato;
	
	
	IBOutlet UITextField *txtDinero;
	
	IBOutlet UIButton *botonSacar;
	IBOutlet UIButton *botonReset;
	
	IBOutlet UIButton *botonInformacion;
	IBOutlet UIView	*vistaInformacion;
	IBOutlet UIImageView *fondoInformacion;
	IBOutlet UITextView *textoInformacion;
	
	
	int pageNumber;
	float dineroAnadirAhorro;

}
@property (nonatomic,retain)IBOutlet UILabel *lblTitulo;
@property (nonatomic,retain)IBOutlet UILabel *lblPresupuesto;
@property (nonatomic,retain)IBOutlet UILabel *lblGastado;
@property (nonatomic,retain)IBOutlet UILabel *lblPorcentaje;
@property (nonatomic,retain)IBOutlet UILabel *lblUltimoGasto;
@property (nonatomic,retain)IBOutlet UILabel *lblFechaReset;
@property (nonatomic,retain)IBOutlet UILabel *lblMonedaPresupuesto;
@property (nonatomic,retain)IBOutlet UILabel *lblMonedaGastado;
@property (nonatomic,retain)IBOutlet UILabel *lblMonedaUltimoGasto;


@property (nonatomic,retain)IBOutlet UILabel *presupuestoDato;
@property (nonatomic,retain)IBOutlet UILabel *gastadoDato;
@property (nonatomic,retain)IBOutlet UILabel *porcentajeDato;
@property (nonatomic,retain)IBOutlet UILabel *ultimoGastoDato;
@property (nonatomic,retain)IBOutlet UILabel *fechaResetDato;


@property (nonatomic,retain)IBOutlet UITextField *txtDinero;

@property (nonatomic,retain)IBOutlet UIButton *botonSacar;
@property (nonatomic,retain)IBOutlet UIButton *botonReset;

@property (nonatomic,retain)IBOutlet UIImageView *fondoInformacion;
@property (nonatomic,retain)IBOutlet UITextView *textoInformacion;
@property (nonatomic)int pageNumber;
@property (nonatomic)float dineroAnadirAhorro;



- (id)initWithPageNumber:(int)page;
-(IBAction)sacarDineroSobre:(id)sender;
-(IBAction)resetDineroSobre:(id)sender;
-(void)cargarDetalleVista;
-(IBAction)ocultarTeclado:(id)sender;
-(IBAction)mostrarInformacion:(id)sender;
-(IBAction)eventoEmpezarEditar:(id)sender;




@end
