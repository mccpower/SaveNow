//
//  untitled.h
//  EFM
//
//  Created by Noemi on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFMAppDelegate.h"

@interface PreferenciasController : UIViewController <UIActionSheetDelegate>{
	
	IBOutlet UILabel *lblSobre0;
	IBOutlet UILabel *lblSobre1;
	IBOutlet UILabel *lblSobre2;
	IBOutlet UILabel *lblSobre3;
	IBOutlet UILabel *lblSobre4;
	
	IBOutlet UITextField *txtSobre0;
	IBOutlet UITextField *txtSobre1;
	IBOutlet UITextField *txtSobre2;
	IBOutlet UITextField *txtSobre3;
	IBOutlet UITextField *txtSobre4;
	
	IBOutlet UILabel *tituloPresupuestosSobres;
	IBOutlet UILabel *tituloMoneda;
	IBOutlet UILabel *tituloTotal;
	IBOutlet UILabel *totalDato;

	IBOutlet UISegmentedControl *segmEleccionMoneda;
	
	NSNumber *sobreActualizar;
	NSNumber *presupuestoActualizar;

}

@property (nonatomic,retain) IBOutlet UILabel *lblSobre0;
@property (nonatomic,retain) IBOutlet UILabel *lblSobre1;
@property (nonatomic,retain) IBOutlet UILabel *lblSobre2;
@property (nonatomic,retain) IBOutlet UILabel *lblSobre3;
@property (nonatomic,retain) IBOutlet UILabel *lblSobre4;

@property (nonatomic,retain) IBOutlet UITextField *txtSobre0;
@property (nonatomic,retain) IBOutlet UITextField *txtSobre1;
@property (nonatomic,retain) IBOutlet UITextField *txtSobre2;
@property (nonatomic,retain) IBOutlet UITextField *txtSobre3;
@property (nonatomic,retain) IBOutlet UITextField *txtSobre4;

@property (nonatomic,retain) IBOutlet UILabel *tituloPresupuestosSobres;
@property (nonatomic,retain) IBOutlet UILabel *tituloMoneda;
@property (nonatomic,retain) IBOutlet UILabel *tituloTotal;

@property (nonatomic,retain) IBOutlet UILabel *totalDato;

@property (nonatomic,retain) IBOutlet UISegmentedControl *segmEleccionMoneda;


@property (nonatomic,retain) NSNumber *sobreActualizar;
@property (nonatomic,retain) NSNumber *presupuestoActualizar;


-(IBAction) botonActualizarPresupuesto:(id)sender;
-(IBAction) vaciarTextbox:(id)sender;
-(IBAction)ocultarTeclado:(id)sender;
-(IBAction)cambiarMoneda:(id)sender;

@end
