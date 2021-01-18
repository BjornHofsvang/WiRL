{******************************************************************************}
{                                                                              }
{       WiRL: RESTful Library for Delphi                                       }
{                                                                              }
{       Copyright (c) 2015-2019 WiRL Team                                      }
{                                                                              }
{       https://github.com/delphi-blocks/WiRL                                  }
{                                                                              }
{******************************************************************************}
unit WiRL.Client.Token;

{$I ..\Core\WiRL.inc}

interface

uses
  System.SysUtils, System.Classes,
  WiRL.Core.JSON,
  WiRL.Client.Resource,
  WiRL.http.Client.Interfaces,
  WiRL.http.Client;

type
  {$IFDEF HAS_NEW_PIDS}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator32 or pidiOSDevice32 or pidAndroid32Arm)]
  {$ELSE}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice or pidAndroid)]
  {$ENDIF}
  TWiRLClientToken = class(TWiRLClientResource)
  private
    FData: TJSONObject;
    FPassword: string;
    FUsername: string;
    FUserRoles: TStringList;
  protected
    procedure AfterGET(AResponse: IWiRLResponse); override;

    procedure BeforePOST(AContent: TMemoryStream); override;
    procedure AfterPOST(AResponse: IWiRLResponse); override;

    procedure AfterDELETE(AResponse: IWiRLResponse); override;

    procedure ParseData; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Data: TJSONObject read FData;
    property Password: string read FPassword write FPassword;
    property Username: string read FUsername write FUsername;
  end;

implementation

uses
  WiRL.Core.Utils,
  WiRL.Rtti.Utils;

{ TWiRLClientToken }

procedure TWiRLClientToken.AfterDELETE(AResponse: IWiRLResponse);
begin
  inherited;
  if Assigned(FData) then
    FData.Free;
  FData := StreamToJSONValue(AResponse.ContentStream) as TJSONObject;
  ParseData;
end;

procedure TWiRLClientToken.AfterGET(AResponse: IWiRLResponse);
begin
  inherited;
  if Assigned(FData) then
    FData.Free;
  FData := StreamToJSONValue(AResponse.ContentStream) as TJSONObject;
  ParseData;
end;

procedure TWiRLClientToken.AfterPOST(AResponse: IWiRLResponse);
begin
  inherited;

  if Assigned(FData) then
    FData.Free;
  FData := StreamToJSONValue(AResponse.ContentStream) as TJSONObject;
  ParseData;
end;

procedure TWiRLClientToken.BeforePOST(AContent: TMemoryStream);
var
  LStreamWriter: TStreamWriter;
begin
  inherited;
  LStreamWriter := TStreamWriter.Create(AContent);
  try
    LStreamWriter.Write('username=' + FUserName + '&password=' + FPassword);
  finally
    LStreamWriter.Free;
  end;
end;

constructor TWiRLClientToken.Create(AOwner: TComponent);
begin
  inherited;
  FData := TJSONObject.Create;
  FUserRoles := TStringList.Create;
  Resource := 'token';
end;

destructor TWiRLClientToken.Destroy;
begin
  FUserRoles.Free;
  FData.Free;

  inherited;
end;

procedure TWiRLClientToken.ParseData;
begin

end;

end.
